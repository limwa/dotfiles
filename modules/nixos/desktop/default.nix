{...}: {
  imports = [
    ./apps.nix
  ];

  # Enable X11.
  services.xserver.enable = true;

  # Enable GDM as Display Manager.
  services.displayManager.gdm.enable = true;
}
