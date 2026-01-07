{pkgs, ...}: {
  # Flatpak
  # https://nixos.wiki/wiki/Flatpak

  # Enable flatpak.
  services.flatpak.enable = true;

  # Allow graphical installation of Flatpak apps.
  services.gnome.gnome-software.enable = true;

  # Automatically configure the Flathub remote.
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    wants = ["NetworkManager-wait-online.service"];
    after = ["NetworkManager-wait-online.service"];

    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
