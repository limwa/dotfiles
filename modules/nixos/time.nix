{
  # Set the time zone.
  time = {
    timeZone = "Europe/Lisbon";
    hardwareClockInLocalTime = true;
  };

  # Disable timesyncd.
  services.timesyncd.enable = false;

  # Enable chrony with NTS.
  services.chrony = {
    enable = true;
    servers = [ "time.cloudflare.com port 443" ];

    enableNTS = true;
  };
}
