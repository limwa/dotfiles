{user, ...}: {
  # Docker
  # https://nixos.wiki/wiki/Docker

  virtualisation.docker = {
    enable = true;

    # Don't autostart Docker to not waste system resources.
    enableOnBoot = false;

    # Prune unused Docker resources automatically.
    autoPrune.enable = true;
    autoPrune.dates = "daily";
  };

  # Add docker group to the user.
  users.users.${user.login}.extraGroups = ["docker"];
}
