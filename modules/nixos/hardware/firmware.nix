{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  # Enable all firmware.
  hardware.enableAllFirmware = true;

  # Enable fwupd and install gnome-software to manage firmware.
  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Enable gnome-software to manage firmware.
  environment.systemPackages = with pkgs; [
    gnome-software
  ];
}
