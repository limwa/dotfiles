{user, ...}: {
  # Bluetooth Audio
  # https://nixos.wiki/wiki/Bluetooth

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # https://askubuntu.com/questions/676853/bluetooth-headset-with-poor-sound-quality-on-ubuntu
        AutoConnect = true;
        MultiProfile = "multiple";

        # Show battery level of headset.
        Experimental = true;
      };
    };
  };

  # Allow audio and media keys to be used with bluetooth.
  home-manager.users.${user.login} = {
    services.mpris-proxy.enable = true;
  };
}
