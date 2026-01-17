{
  # systemd-resolved
  # https://nixos.wiki/wiki/Systemd-resolved

  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        FallbackDNS = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "opportunistic";
      };
    };
  };
}
