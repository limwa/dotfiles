{
  user,
  pkgs,
  ...
}: {
  # Podman
  # https://nixos.wiki/wiki/Podman

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;

    # Enable docker compatibility.
    dockerCompat = true;
    dockerSocket.enable = true;

    # Prune unused Podman resources automatically.
    autoPrune.enable = true;
    autoPrune.dates = "weekly";
  };

  environment.systemPackages = with pkgs; [
    podman-desktop
  ];

  # Add podman group to the user.
  users.users.${user.login}.extraGroups = ["podman"];
}
