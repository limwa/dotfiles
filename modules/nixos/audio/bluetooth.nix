{user, ...}: {
  # Bluetooth Audio
  # https://nixos.wiki/wiki/Bluetooth
  imports = [./.];

  hardware.bluetooth.enable = true;

  # Allow audio and media keys to be used with bluetooth.
  home-manager.users.${user.login} = {
    services.mpris-proxy.enable = true;
  };
}
