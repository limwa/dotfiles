let
  get-flake = import (builtins.fetchTarball "https://github.com/ursi/get-flake/archive/refs/heads/master.tar.gz");
  flake = get-flake ../.;

  secrets = flake.commonArgs.secrets;

  # ssh-keyscan localhost
  authorized-keys = [
    # AAAAAAAA
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcImQPMbmootqpkmhdw1mrH+5z0NJOvVfiVp0tUE0zk"
  ];
in
  builtins.listToAttrs (
    map (secret: {
      name = "${secret}.age";
      value = {
        publicKeys = authorized-keys;
      };
    })
    secrets
  )
