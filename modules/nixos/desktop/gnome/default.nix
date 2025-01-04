{pkgs, ...}: {
  imports = [
    ../apps.nix
    ./dconf.nix
  ];

  # Enable X11.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.variables = {
    # Needed for Astra Monitor
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

  environment.systemPackages = with pkgs; [
    # Astra Monitor dependencies
    amdgpu_top
    libgtop
    iw
    pciutils
    wirelesstools

    gnomeExtensions.astra-monitor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.media-controls
  ];
}
