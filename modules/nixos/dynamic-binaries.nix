{
  self,
  system,
  pkgs,
  ...
}: {
  # Nix Alien is used to run unpatched dynamic binaries on NixOS.
  # https://github.com/thiagokokada/nix-alien

  environment.systemPackages = [
    self.inputs.nix-alien.packages.${system}.nix-alien

    # steam-run is another way of running unpatched binaries on NixOS.
    pkgs.steam-run
  ];

  # Optional, but this is needed for `nix-alien-ld` command
  programs.nix-ld.enable = true;

  # Enable comma
  programs.nix-index-database.comma.enable = true;
}
