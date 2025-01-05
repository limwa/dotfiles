{user, ...}: {
  # Bluetooth Audio
  # https://nixos.wiki/wiki/Bluetooth
  imports = [./.];

  hardware.bluetooth = {
    enable = true;

    settings = {
      General = {
        # https://askubuntu.com/questions/676853/bluetooth-headset-with-poor-sound-quality-on-ubuntu
        AutoConnect = true;
        MultiProfile = "multiple";

        # Enable experimental features.
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };

  # Allow audio and media keys to be used with bluetooth.
  home-manager.users.${user.login} = {
    services.mpris-proxy.enable = true;
  };
}
