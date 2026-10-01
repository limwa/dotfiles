{
  services.timesyncd.servers = [ "://cloudflare.com" ];
  services.timesyncd.settings = {
    Time = {
      NTS = "yes";
    };
  };
}
