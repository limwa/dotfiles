{
  # The systemd-boot bootloader is used as the default bootloader.
  # However, it is disabled if the secure boot module is imported.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    # configurationLimit = 3;
  };
}
