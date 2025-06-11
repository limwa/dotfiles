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
          name = "dump-make-processes";

          runtimeInputs = [
            pkgs.procps
            pkgs.coreutils
          ];

          text = ''
            current_time="$(date +%Y-%m-%dT%H:%M:%S)"
            pgrep -a make >> "/home/lima/make-processes-$current_time.log"
          '';
        };
      in "${script}/bin/${script.name}";

      TimeoutSec = "infinity";
    };

    wantedBy = ["multi-user.target"];
  };
}
