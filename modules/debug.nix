{pkgs, ...}: {
  # https://unix.stackexchange.com/questions/739363/a-systemd-service-that-runs-just-before-shutdown-and-uses-a-mounted-filesystem
  systemd.services."dump-make-processes" = {
    unitConfig = {
      Description = "Dump make processes";
      RequiresMountsFor = ["/home"];
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "true";
      ExecStop = "ps aux | grep make >> /home/lima/make-processes-$(date +%Y-%m-%d_%H-%M-%S).txt";

      TimeoutSec = "infinity";
    };

    path = with pkgs; [
      ps
      gnugrep
    ];

    wantedBy = ["multi-user.target"];
  };
}
