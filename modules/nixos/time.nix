{
  # Set the time zone.
  time.timeZone = "Europe/Lisbon";

  # Disable timesyncd.
  services.timesyncd.enable = false;

  # Enable chrony with NTS.
  services.chrony = {
    enable = true;
    servers = [ "://cloudflare.com nts" ];
  };
}
