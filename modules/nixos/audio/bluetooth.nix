{ user, ... }:
{
  # Bluetooth Audio
  # https://nixos.wiki/wiki/Bluetooth
  imports = [ ./. ];

  hardware.bluetooth = {
    enable = true;
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
