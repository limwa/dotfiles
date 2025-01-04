{
  lib,
  self,
  ...
}: let
  lanzaboote = self.inputs.lanzaboote;
in {
  # Secure Boot (ready to be enforced)
  # https://nixos.wiki/wiki/Secure_Boot

  imports = [
    lanzaboote.nixosModules.lanzaboote
    ./.
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
