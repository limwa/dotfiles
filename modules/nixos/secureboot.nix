{
  lib,
  self,
  pkgs,
  ...
}:
let
  lanzaboote = self.inputs.lanzaboote;
in
{
  # Secure Boot
  # https://nix-community.github.io/lanzaboote/

  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";

    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };

    settings = {
      default = "@saved";
    };
  };

  # Workaround: https://github.com/nix-community/lanzaboote/issues/624
  boot.bootspec.enable = lib.mkForce false;
}
