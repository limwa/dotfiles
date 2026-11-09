{
  user,
  pkgs,
  ...
}:
{
  # Bluetooth Audio
  # https://nixos.wiki/wiki/Bluetooth
  imports = [ ./. ];

  hardware.bluetooth = {
    enable = true;

    # TEMPORARY: BlueZ 5.88 (2026-11-05) for LE Audio duplex fixes, e.g.
    # "transport: Don't disable desynchronized links on release" and
    # "bap: Recreate stream IO after an early Enable".
    # Drop this once nixpkgs ships bluez >= 5.88.
    package = pkgs.bluez.overrideAttrs (old: {
      version = "5.88";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/bluetooth/bluez-5.88.tar.xz";
        hash = "sha256-aVLDnrX4sO5xLMUKs7z/A74XxBDdl8pkD0hJ2aFlO6M=";
      };
      # nixpkgs' lreadline.patch rebased onto 5.88 (some hunks moved). The UUID
      # discovery crash fix nixpkgs carries for 5.87 is already part of 5.88.
      patches = [ ./patches/bluez-5.88-lreadline.patch ];
      # 5.88 removed the deprecated attrib/ directory (gatttool) entirely.
      postInstall =
        builtins.replaceStrings [ "install -Dm755 attrib/gatttool $out/bin/gatttool" ] [ "" ]
          old.postInstall;
    });

    settings = {
      General = {
        Experimental = true;
        KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e"; # ISO sockets for LE Audio
      };
    };
  };

  # Allow audio and media keys to be used with bluetooth.
  home-manager.users.${user.login} = {
    services.mpris-proxy.enable = true;
  };
}
