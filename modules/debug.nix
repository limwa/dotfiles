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
      ExecStart = "/bin/true";
      ExecStop = let
        bash = "${pkgs.bash}/bin/bash";
        ps = "${pkgs.ps}/bin/ps";
        grep = "${pkgs.gnugrep}/bin/grep";
        date = "${pkgs.coreutils}/bin/date";
        # sleep = "${pkgs.coreutils}/bin/sleep";
      in "${bash} -c ' ${ps} aux | ${grep} make >> /home/lima/make-processes-$(${date} +%Y-%m-%d_%H-%M-%S).txt'";

      TimeoutSec = "infinity";
    };

    wantedBy = ["multi-user.target"];
  };
}
