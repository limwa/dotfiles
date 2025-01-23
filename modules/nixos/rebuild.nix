{
  pkgs,
  user,
  ...
}: let
  version = "1.0.1";
  system-rebuild =
    # This script will take only the changes that were added to the Git
    # index and try to rebuild the system with them.
    # If the rebuild is successful, it will commit the changes.
    pkgs.writeShellApplication rec {
      name = "system-rebuild";

      meta = {
        description = "Rebuild NixOS system with Git synchronization";
        license = pkgs.lib.licenses.mit;
      };

      derivationArgs = let
        pname = "limwa-dotfiles-${name}";
      in {
        inherit pname version;
        name = "${pname}-${version}";
      };

      runtimeInputs = with pkgs; [
        libnotify
        yq-go
      ];

      text = ''
        get_options() {
          getopt -n "${name}" \
            -o h -l help \
                 -l always-rebuild \
            -- "$@"
        }

        opts="$(get_options "$@")"
        eval set -- "$opts"

        REBUILD_FORCE=false

        while true; do
            case "$1" in
            -h|--help)
                echo "Usage: ${name} [OPTIONS]"
                echo
                echo "Rebuild NixOS system with Git synchronization."
                echo
                echo "Options:"
                echo "  -h, --help   Show this help message and exit."
                echo "  -f, --force  Force rebuild, even if there are no changes to commit."
                echo
                exit 0
                ;;
            -f|--force)
                shift
                REBUILD_FORCE=true
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Invalid option: $1"
                exit 1
                ;;
            esac
        done

        HOST="$(hostname)"
        CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        RESERVED_BRANCH="reserved/dotfiles/$HOST"

        checkout_current_branch() {
          echo ">> checkout current branch"
          git checkout "$CURRENT_BRANCH"
        }

        prepare_reserved_branch() {
          echo ">> prepare reserved branch"

          git checkout "$CURRENT_BRANCH"
          git branch -D "$RESERVED_BRANCH" || true
          git checkout -b "$RESERVED_BRANCH"
        }

        checkout_reserved_branch() {
          echo ">> checkout reserved branch"
          git checkout "$RESERVED_BRANCH"
        }

        stash_all() {
          echo ">> stash all"

          prepare_reserved_branch

          git commit -m "stash-all: staged" --allow-empty
          git commit -m "stash-all: unstaged" --allow-empty -a
          git add . && git commit -m "stash-all: untracked" --allow-empty

          checkout_current_branch
        }

        unstash_all() {
          echo ">> unstash all"

          checkout_reserved_branch

          git reset HEAD^^ # untracked and unstaged
          git reset --soft HEAD^ # staged

          checkout_current_branch
        }

        unstash_staged() {
          echo ">> unstash staged"

          git cherry-pick "$RESERVED_BRANCH^^" # staged

          checkout_reserved_branch
          git rebase "$CURRENT_BRANCH"

          checkout_current_branch
          git reset --soft HEAD^ # staged
        }

        unstash_remaining() {
          echo ">> unstash remaining"

          checkout_reserved_branch
          git reset "$CURRENT_BRANCH"
          checkout_current_branch

          git branch -D "$RESERVED_BRANCH"
        }

        sync_local_repo() {
          stash_all
          git pull -q || true
          unstash_all
        }

        get_last_built_commit() {
          git rev-parse --verify --quiet "$HOST^{}" || echo "<not-found>"
        }

        should_rebuild() {
          if [ "$REBUILD_FORCE" == "true" ]; then
              return 0
          fi

          last_built_commit=$(get_last_built_commit)
          current_commit=$(git rev-parse HEAD)

          # Only rebuild if there are new commits OR there are staged changes
          if [ "$last_built_commit" == "$current_commit" ] && git diff --staged --quiet; then
              echo "No new changes detected, exiting."
              echo

              return 1
          fi
        }

        build_and_switch() {
          echo "Rebuilding NixOS..."
          echo

          sudo nixos-rebuild boot --flake .#
          sudo nixos-rebuild switch --flake .# || true

          echo
        }


        # Go to the config directory
        pushd ~/dotfiles/
        echo

        sync_local_repo

        if ! should_rebuild; then
          popd
          exit 0
        fi

        stash_all
        unstash_staged
        trap "unstash_remaining" EXIT

        # Format files with `nix fmt` and report errors, if any
        nix fmt . &> /dev/null || nix fmt .
        git add .

        # Show changes
        git diff --staged '*.nix'

        build_and_switch

        # Generate commit message
        message=$(nixos-rebuild list-generations --json | yq -p=json ".[] | select(.current == true) | \"rebuild($HOST): generation \(.generation), NixOS \(.nixosVersion) with Linux Kernel \(.kernelVersion)\"")

        # Commit all changes witih the generation metadata
        git commit -m "$message" || true
        git tag -af -m "$HOST" "$HOST"

        # No need to keep the changes stashed
        # and we need to unstash them before popd
        trap - EXIT
        unstash_remaining

        # Update remote
        git push -q
        git push -q --tags --force

        # Notify all OK!
        notify-send -e "NixOS succesfuly rebuilt!" --icon=software-update-available

        # Back to where you were
        echo
        popd
      '';
    };
in {
  users.users.${user.login}.packages = [system-rebuild];
}
