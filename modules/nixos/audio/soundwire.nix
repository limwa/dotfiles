{pkgs, ...}: let
  soundwire.port = 59010;
in {
  # SoundWire

  networking.firewall.allowedTCPPorts = [soundwire.port];
  networking.firewall.allowedUDPPorts = [soundwire.port];

  environment.systemPackages = with pkgs; [
    soundwireserver
    pavucontrol
  ];
}
