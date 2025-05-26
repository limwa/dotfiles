{pkgs, ...}: {
  imports = [
    ../default.nix
    ./dconf.nix
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;

  # KDE Connect on GNOME
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

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

    gnomeExtensions.applications-menu
    gnomeExtensions.astra-monitor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.media-controls
  ];
}
