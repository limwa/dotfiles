{
  # The systemd-boot bootloader is used as the default bootloader.
  # However, it is disabled if the secure boot module is imported.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
