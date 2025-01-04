{user, ...}: {
  # Enable networking.
  networking.networkmanager.enable = true;
  users.users.${user.login}.extraGroups = ["networkmanager"];

  # Fix for L2TP VPN crashing when establishing connection.
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };

  # Enable Tailscale.
  services.tailscale.enable = true;
}
