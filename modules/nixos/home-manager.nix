{
  lib,
  self,
  ...
}: let
  home-manager = self.inputs.home-manager;
in {
  # Home Manager
  # https://nixos.wiki/wiki/Home_Manager

  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.useUserPackages = lib.mkDefault true;
  home-manager.useGlobalPkgs = lib.mkDefault true;
  home-manager.backupFileExtension = lib.mkDefault "bak";
}
