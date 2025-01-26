{user, ...}: {
  # Enable networking.
  networking.networkmanager.enable = true;
  users.users.${user.login}.extraGroups = ["networkmanager"];

  # Fix for L2TP VPN crashing when establishing connection.
  networking.networkmanager.enableStrongSwan = true;
  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  # Enable Tailscale.
  services.tailscale.enable = true;
}
