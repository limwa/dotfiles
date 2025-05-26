{...}: {
  imports = [
    ./apps.nix
  ];

  # Enable X11.
  services.xserver.enable = true;

  # Enable GDM as Display Manager.
  services.xserver.displayManager.gdm.enable = true;
}
