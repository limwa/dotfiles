{
  user,
  pkgs,
  ...
}: {
  # Docker
  # https://nixos.wiki/wiki/Docker

  virtualisation.docker = {
    enable = true;

    # Don't autostart Docker to not waste system resources.
    enableOnBoot = false;

    # Prune unused Docker resources automatically.
    autoPrune.enable = true;
    autoPrune.dates = "daily";

    # Don't store passwords in plain text.
    extraPackages = with pkgs; [
      docker-credential-helpers
    ];
  };

  # Add docker group to the user.
  users.users.${user.login}.extraGroups = ["docker"];
}
