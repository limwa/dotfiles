{
  user,
  pkgs,
  ...
}:
{
  # Enable networking.
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-strongswan
    ];
  };

  security.pki.certificateFiles = [ ../../files/certificates/HARICA-GEANT-TLS-R1.crt ];

  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  # Fix for L2TP VPN crashing when establishing connection.
  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  # Enable Tailscale.
  services.tailscale.enable = true;

  # Enable firewalld.
  networking.nftables.enable = true;
  services.firewalld = {
    enable = true;
    package = pkgs.firewalld-gui;
  };
}
