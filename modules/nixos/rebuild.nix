{
  pkgs,
  user,
  ...
}: let
  version = "1.0.0";
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
        # Go to the config directory
        pushd ~/dotfiles/
        echo

        # Sync local repository with remote changes
        git stash clear
        git stash push -qu
        trap "git stash pop -q --index" EXIT
        git pull -q --no-autostash
        trap - EXIT
        git stash pop -q --index || true

        # Get the name of the host
        HOST=$(hostname)

        # Get commit that was last built and current commit
        last_built_commit=$(git rev-parse --verify --quiet "$HOST^{}" || echo "<not-found>")
        current_commit=$(git rev-parse HEAD)

        # Only rebuild if there are new commits OR there are staged changes
        if [ "$last_built_commit" == "$current_commit" ] && git diff --staged --quiet; then
          echo "No new changes detected, exiting."
          echo

          popd
          exit 0
        fi

        # Remove any changes that were not added to the index
        git stash clear
        git stash push -qku
        trap "git stash pop -q" EXIT

        # Format files with `nix fmt` and report errors, if any
        nix fmt . &> /dev/null || nix fmt .
        git add .

        # Show changes
        git diff --staged '*.nix'

        echo "Rebuilding NixOS..."

        echo
        sudo nixos-rebuild boot --flake .#
        sudo nixos-rebuild switch --flake .# || true
        echo

        # Generate commit message
        message=$(nixos-rebuild list-generations --json | yq -p=json ".[] | select(.current == true) | \"rebuild($HOST): generation \(.generation), NixOS \(.nixosVersion) with Linux Kernel \(.kernelVersion)\"")

        # Commit all changes witih the generation metadata
        git commit -m "$message" || true
        git tag -af -m "$HOST" "$HOST"

        # No need to keep the changes stashed
        # and we need to unstash them before popd
        trap - EXIT
        git stash pop -q || true

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
