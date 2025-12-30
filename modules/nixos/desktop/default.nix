{...}: {
  imports = [
    ./apps.nix
  ];

  # Enable GDM as Display Manager.
  services.displayManager.gdm.enable = true;

  # Use gnome as default desktop environment.
  services.displayManager.defaultSession = "gnome";
}
