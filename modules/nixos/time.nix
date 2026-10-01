{
  # Set the time zone.
  time.timeZone = "Europe/Lisbon";

  # Disable timesyncd.
  services.timesyncd.enable = false;

  # Enable chrony with NTS.
  services.chrony = {
    enable = true;
    enableNTS = true;

    servers = [
      "time.cloudflare.com"
      "nts.netnod.se"
      "ptbtime1.ptb.de"
      "ptbtime2.ptb.de"
    ];
  };
}
