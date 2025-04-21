{
  # systemd-resolved
  # https://nixos.wiki/wiki/Systemd-resolved

  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

  services.resolved = {
    enable = true;

    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    dnssec = "allow-downgrade";
    dnsovertls = "opportunistic";
  };
}
