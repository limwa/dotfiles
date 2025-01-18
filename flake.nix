{
  description = "A flake for my NixOS configurations";

  inputs = {
    # Nixpkgs (NixOS unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nixpkgs (NixOS stable)
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Flake Utils
    flake-utils.url = "github:numtide/flake-utils";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Lanzaboote (doesn't follow nixpkgs to ensure stability)
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    # lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Alien (doesn't follow nixpkgs to ensure index is accurate)
    nix-alien.url = "github:thiagokokada/nix-alien";

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    disko,
    flake-utils,
    ...
  }: let
    allSystemsFlakeAttrs = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        # Use alejandra to format the Nix code
        formatter = pkgs.alejandra;

        packages = {
          create-update-summary = pkgs.writeShellApplication {
            name = "dotfiles-create-update-summary";

            runtimeInputs = with pkgs; [
              yq-go
            ];

            text = ''
              flake_dir="$(realpath "''${1:-.}")"
              pushd "$flake_dir"

              build_dir="$(mktemp -d)"
              trap 'rm -rf "$build_dir"' EXIT

              # Create a summary file
              summary_file="$build_dir/summary.md"

              {
                echo "# Package Changes"
                echo
              } > "$summary_file"

              # For all available hosts, the script will try to build their
              # current and new configurations, as well as output the
              # differences between them, if any.

              current_config_ref="$(git rev-parse --abbrev-ref HEAD)"
              current_config_commit="$(git rev-parse "$current_config_ref")"

              for host in $(nix eval --json ".#meta.hosts" | yq -p json '.[]'); do
                echo
                echo "> Host: $host"

                # Get previous configuration
                old_config_commit="$(git rev-parse --verify --quiet "$host^{}" || true)"
                if [ -z "$old_config_commit" ] || [ "$old_config_commit" == "$current_config_commit" ]; then
                  echo
                  echo ">> No changes detected, skipping."
                  echo ">>> Old configuration commit: $old_config_commit"
                  echo ">>> Current configuration commit: $current_config_commit"

                  {
                    echo "## $host"
                    echo
                    echo "$host is up to date."
                    echo
                  } >> "$summary_file"

                  continue
                fi

                diff_file="$build_dir/$host.diff"
                log_file="$build_dir/$host.log"

                echo
                echo ">> Current Configuration"
                git checkout --quiet "$current_config_commit"

                # https://stackoverflow.com/questions/692000/how-do-i-write-standard-error-to-a-file-while-using-tee-with-a-pipe
                if current_config_drv="$(nix eval --raw .#nixosConfigurations."$host".config.system.build.toplevel.drvPath 2> >(tee "$log_file" >&2))"; then
                  echo
                  echo ">> Old Configuration"
                  git checkout --quiet "$old_config_commit"

                  old_config_drv="$(nix eval --raw .#nixosConfigurations."$host".config.system.build.toplevel.drvPath)"
                  nix store diff-closures "$old_config_drv" "$current_config_drv" > "$diff_file"

                  {
                    echo "## $host"
                    echo
                    echo "$host was successfully built."
                    if [ -s "$diff_file" ]; then
                      echo
                      echo "### \`nix store diff-closures [old] [new]\`"
                      echo
                      echo '```asc'
                      cat "$diff_file"
                      echo '```'
                      echo
                    else
                      echo "There were no changes detected."
                      echo
                    fi
                  } >> "$summary_file"

                else

                  {
                    echo "## $host"
                    echo
                    echo "$host failed to build."
                    echo
                  } >> "$summary_file"

                fi

                if [ -s "$log_file" ]; then
                  echo "### Build log"
                  echo
                  echo '```nix'
                  cat "$log_file"
                  echo '```'
                  echo
                fi

              done

              sed -i -e $'s/\x1b\[[0-9;]*m//g' "$summary_file"

              git checkout --quiet "$current_config_ref"
              cp "$summary_file" summary.md

              popd
            '';
          };
        };
      }
    );
  in
    allSystemsFlakeAttrs
    // {
      # Common arguments passed to all hosts' configurations
      commonArgs = {
        initialPassword = "nixos";

        usePortugueseKeyboard = true;
        useEpsonDrivers = true;

        user = {
          login = "lima";
          email = "me@limwa.pt";
          displayName = "André Lima";
          signingKey = "C897FE7F98151B542F969177F55F5AE242E116E4";
        };
      };

      meta = {
        hosts = builtins.attrNames self.nixosConfigurations;
      };

      nixosConfigurations = let
        commonModules = [
          disko.nixosModules.disko
          ./modules/nixos/audio
          ./modules/nixos/desktop/gnome
          ./modules/nixos/development/adb.nix
          ./modules/nixos/development/ccache.nix
          ./modules/nixos/development/documentation.nix
          ./modules/nixos/development/nixd.nix
          ./modules/nixos/hardware/firmware.nix
          ./modules/nixos/hardware/printing.nix
          ./modules/nixos/hardware/tlp.nix
          ./modules/nixos/secureboot
          ./modules/nixos/virtualization/docker
          ./modules/nixos/virtualization/libvirt.nix
          ./modules/nixos/virtualization/virtualbox.nix
          ./modules/nixos/bootloader.nix
          ./modules/nixos/common.nix
          ./modules/nixos/dns-over-tls.nix
          ./modules/nixos/dynamic-binaries.nix
          ./modules/nixos/flatpak.nix
          ./modules/nixos/fonts.nix
          ./modules/nixos/home-manager.nix
          ./modules/nixos/kernel.nix
          ./modules/nixos/keyboard.nix
          ./modules/nixos/locale.nix
          ./modules/nixos/networking.nix
          ./modules/nixos/nix.nix
          ./modules/nixos/rebuild.nix
          ./modules/nixos/user.nix
          ./modules/home-manager/p10k
          ./modules/home-manager/bat.nix
          ./modules/home-manager/direnv.nix
          ./modules/home-manager/git.nix
          ./modules/home-manager/zsh.nix
        ];

        mkSystem = system: attrs: let
          recursiveMerge = attrList: let
            f = with nixpkgs.lib;
              attrPath:
                zipAttrsWith (
                  n: values:
                    if tail values == []
                    then head values
                    else if all isList values
                    then unique (concatLists values)
                    else if all isAttrs values
                    then f (attrPath ++ [n]) values
                    else last values
                );
          in
            f [] attrList;

          # Add `pkgs.unfree` and `pkgs.stable`
          nixpkgs-overlay-add-unfree-and-stable = {
            nixpkgs.overlays = [
              (final: prev: {
                # unfree = import nixpkgs {
                #   inherit system;
                #   config.allowUnfree = true;
                # };

                stable = import nixpkgs-stable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          };

          system-cfg = recursiveMerge [
            {
              inherit system;

              modules =
                commonModules
                ++ [
                  # Nixpkgs overlay
                  nixpkgs-overlay-add-unfree-and-stable
                ];

              specialArgs =
                self.commonArgs
                // {
                  inherit self system;
                };
            }

            attrs
          ];
        in
          nixpkgs.lib.nixosSystem system-cfg;
      in {
        AAAAAAAA = mkSystem "x86_64-linux" {
          modules = [
            ./hosts/AAAAAAAA/configuration.nix
          ];

          specialArgs = {
            useEpsonDrivers = true;
          };
        };
      };
    };
}
