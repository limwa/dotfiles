{
  user,
  pkgs,
  ...
}: {
  home-manager.users.${user.login} = {
    # SSH
    # https://mynixos.com/home-manager/options/programs.ssh
    programs.ssh = {
      matchBlocks = {
        # Easy way to connect to VM for thesis development.
        thesis = {
          host = "thesis";
          hostname = "127.0.0.1";
          user = "lima";
          port = 6922;
        };
      };
    };
  };

  # https://unix.stackexchange.com/questions/739363/a-systemd-service-that-runs-just-before-shutdown-and-uses-a-mounted-filesystem
  systemd.services."dump-shutdown-processes" = {
    unitConfig = {
      Description = "Dump shutdown processes";
      RequiresMountsFor = ["/home"];
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = let
        script = pkgs.writeShellApplication {
          name = "dump-shutdown-processes";

          runtimeInputs = [
            pkgs.procps
            pkgs.coreutils
          ];

          text = ''
            current_time="$(date +%Y-%m-%dT%H:%M:%S)"
            dump_file="/home/lima/shutdown-processes-$current_time.log"

            # Dump all processes
            for pid in $(pgrep \.); do
              printf '> PID=%s EXE=%s CWD=%s CMD=%s\n' \
                "$pid" \
                "$(realpath "/proc/$pid/exe")" \
                "$(realpath "/proc/$pid/cwd")" \
                "$(cat "/proc/$pid/cmdline")" >> "$dump_file"
            done

            echo "Done!" >> "$dump_file"
          '';
        };
      in "${script}/bin/${script.name}";

      TimeoutSec = "infinity";
    };

    wantedBy = ["multi-user.target"];
  };
}
