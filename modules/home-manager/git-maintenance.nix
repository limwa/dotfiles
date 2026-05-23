{
  user,
  pkgs,
  ...
}:
{
  home-manager.users.${user.login} = {

    programs.git = {
      maintenance.enable = true;

      includes = [
        {
          # This file is managed by a systemd unit that adds repositories to it, so we need to include it here.
          path = "~/.config/git/maintenance.generated.inc";
        }
      ];
    };

    systemd.user = {
      paths.git-maintenance-sync-repositories = {
        Unit.Description = "Watch ~/.git-maintenance for changes";
        Install.WantedBy = [ "paths.target" ];

        Path = {
          # %h is the systemd specifier for the user's home directory
          PathChanged = "%h/.git-maintenance";
          MakeDirectory = true;
        };
      };

      services.git-maintenance-sync-repositories = {
        Unit.Description = "Sync git maintenance targets based on symlinks in ~/.git-maintenance";
        Install.WantedBy = [ "default.target" ];

        Service = {
          Type = "oneshot";

          ExecStart =
            let
              synchronizer = pkgs.writeShellApplication {
                name = "git-maintenance-sync-repositories";

                runtimeInputs = with pkgs; [
                  coreutils
                  gitMinimal
                ];

                text = ''
                  MAINTENANCE_DIR="$HOME/.git-maintenance"
                  DELAY=5

                  # 1. Exit immediately if the directory is empty.
                  if [ -z "$(ls -A "$MAINTENANCE_DIR")" ]; then
                    exit 0
                  fi

                  # 2. Loop until the directory hasn't been modified for $DELAY seconds
                  while true; do
                    LAST_MOD=$(stat -c %Y "$MAINTENANCE_DIR")
                    NOW=$(date +%s)
                    DIFF=$((NOW - LAST_MOD))
                    
                    if (( DIFF >= DELAY )); then
                      # 10 seconds have passed with no changes
                      break
                    fi
                    
                    sleep $(( DELAY - DIFF ))
                  done

                  # 3. Generate the maintenance configuration file based on the symlinks in the directory.
                  CONFIG_FILE="$HOME/.config/git/maintenance.generated.inc"
                  mkdir -p "$(dirname "$CONFIG_FILE")"

                  TMP_FILE="$CONFIG_FILE.tmp"
                  echo "# Generated automatically by systemd" > "$TMP_FILE"

                  mkdir -p "$HOME/.git-maintenance"
                  for link in "$HOME/.git-maintenance"/*; do
                    if [ -L "$link" ]; then
                      REAL_PATH="$(readlink -f "$link")"

                      if ! [ -d "$REAL_PATH" ]; then
                        echo "Warning: Target $REAL_PATH of link $link is not a directory. Skipping."
                        continue
                      fi
                     
                      if ! git rev-parse --git-dir > /dev/null 2>&1; then
                        echo "Warning: Target $REAL_PATH of link $link is not a git repository. Skipping."
                        continue
                      fi
                      
                      git config set \
                        --file "$TMP_FILE" \
                        --comment "$(basename "$link")" \
                        --append \
                        maintenance.repo "$REAL_PATH"
                    fi
                  done

                  mv "$TMP_FILE" "$CONFIG_FILE"
                '';
              };
            in
            "${synchronizer}/bin/${synchronizer.meta.mainProgram}";
        };
      };
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "git-maintenance-auto-detect";

        runtimeInputs = with pkgs; [
          coreutils
          fd
          gitMinimal
        ];

        text = ''
          function find_git_repositories() {
            local search_path="$1"

            fd --search-path "$search_path" \
              --no-follow \
              --hidden --glob '.git' \
              --exec git -C "{//}" rev-parse --show-toplevel 2>/dev/null || true
          }

          function get_git_common_dir() {
            local repository="$1"
            local git_common_dir
            git_common_dir="$(git -C "$repository" rev-parse --git-common-dir)"

            if [[ "$git_common_dir" != /* ]]; then
              git_common_dir="''${repository}/''${git_common_dir}"
            fi

            realpath "$git_common_dir"
          }

          function link_git_directory() {
            local links_directory="$1"
            local repository_common_dir="$2"

            local vanity_name
            vanity_name="''${repository_common_dir#"$HOME"/}"
            vanity_name="''${vanity_name//[!a-zA-Z0-9-]/-}"
            vanity_name="$vanity_name-$(sha256sum <<< "$repository_common_dir" | cut -c1-8)"

            local link_path="$links_directory/$vanity_name"

            if [[ -e "$link_path" ]]; then
              if [[ "$(readlink -f "$link_path")" == "$repository_common_dir" ]]; then
                return
              else
                echo "Warning: Link path $link_path already exists and points to a different location. Skipping $repository_common_dir."
                return
              fi
            fi

            ln -sv "$repository_common_dir" "$links_directory/$vanity_name"
          }

          if [ "$#" -lt 1 ]; then
            echo "Usage: $0 <directory>"
            exit 1
          fi

          mkdir -p "$HOME/.git-maintenance"

          find_git_repositories "$1" \
            | while read -r repository; do get_git_common_dir "$repository"; done \
            | LC_ALL="C" sort -u \
            | while read -r common_dir; do link_git_directory "$HOME/.git-maintenance" "$common_dir"; done
        '';
      })
    ];
  };
}
