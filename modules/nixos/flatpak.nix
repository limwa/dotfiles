{pkgs, ...}: {
  # Flatpak
  # https://nixos.wiki/wiki/Flatpak

  # Enable flatpak.
  services.flatpak.enable = true;

  # Allow graphical installation of Flatpak apps.
  environment.systemPackages = [pkgs.gnome-software];

  # Automatically configure the Flathub remote.
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];

    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
