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
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = let
        script = pkgs.writeShellApplication {
          name = "dump-m_a_ke-processes";

          runtimeInputs = [
            pkgs.procps
            pkgs.coreutils
          ];

          text = ''
            current_time="$(date +%Y-%m-%dT%H:%M:%S)"

            for pid in $(pgrep make); do
              {
                echo "Process"
                echo "$pid"
                realpath "/proc/$pid/exe"
                realpath "/proc/$pid/cwd"
                cat "/proc/$pid/cmdline"
                echo "Done"

              } >> "/home/lima/make-processes-$current_time.log"
            done
          '';
        };
      in "${script}/bin/${script.name}";

      TimeoutSec = "infinity";
    };

    wantedBy = ["multi-user.target"];
  };
}
