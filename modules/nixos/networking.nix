{user, pkgs, ...}: {
  # Enable networking.
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ 
      networkmanager-fortisslvpn
      networkmanager-iodine
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-sstp
      networkmanager-strongswan
      networkmanager-vpnc
    ];
  };

  users.users.${user.login}.extraGroups = ["networkmanager"];

  # Fix for L2TP VPN crashing when establishing connection.
  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  # Enable Tailscale.
  services.tailscale.enable = true;
}