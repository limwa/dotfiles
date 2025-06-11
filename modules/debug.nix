{pkgs, ...}: {
  systemd.services."dump-make-processes" = {
    unitConfig = {
      Description = "Dump make processes";
      RequiresMountsFor = ["/home"];
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/true";
      ExecStop = "${pkgs.bash}/bin/bash -c '${pkgs.ps}/bin/ps aux | ${pkgs.gnugrep}/bin/grep make >> /home/lima/make-processes-$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S).txt'";
      TimeoutSec = "infinity";
    };
  };
}
