{
  self,
  system,
  pkgs,
  ...
}: let
  nix-alien-pkgs = self.inputs.nix-alien.packages.${system};
in {
  # Nix Alien is used to run unpatched dynamic binaries on NixOS.
  # https://github.com/thiagokokada/nix-alien

  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
    nix-index-update

    # steam-run is another way of running unpatched binaries on NixOS.
    pkgs.steam-run
  ];

  # Optional, but this is needed for `nix-alien-ld` command
  programs.nix-ld.enable = true;
}
