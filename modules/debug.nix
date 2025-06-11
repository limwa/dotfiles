{pkgs, ...}: {
  # https://unix.stackexchange.com/questions/739363/a-systemd-service-that-runs-just-before-shutdown-and-uses-a-mounted-filesystem
  systemd.services."dump-make-processes" = {
    unitConfig = {
      Description = "Dump make processes";
      RequiresMountsFor = ["/home"];
    };

    serviceConfig = let
      bin = {
        bash = "${pkgs.bashNonInteractive}/bin/bash";
        date = "${pkgs.coreutils}/bin/date";
        grep = "${pkgs.gnugrep}/bin/grep";
        ps = "${pkgs.ps}/bin/ps";
        true = "${pkgs.coreutils}/bin/true";
      };
      # sleep = "${pkgs.coreutils}/bin/sleep";
    in {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${bin.true}";
      ExecStop = "${bin.ps} aux | ${bin.grep} make >> /home/lima/make-processes-$(${bin.date} +%Y-%m-%d_%H-%M-%S).txt";

      TimeoutSec = "infinity";
    };

    wantedBy = ["multi-user.target"];
  };
}
