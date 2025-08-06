{
  user,
  pkgs,
  ...
}: {
  # Libvirt and Virt-manager
  # https://nixos.wiki/wiki/Virt-manager

  # Enable virt-manager.
  programs.virt-manager.enable = true;

  # Enable libvirtd.
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";

    nss = {
      enable = true;
      enableGuest = true;
    };

    qemu = {
      package = pkgs.qemu_full;
      swtpm.enable = true;
    };
  };

  # Add libvirtd group to the user.
  users.users.${user.login}.extraGroups = ["libvirtd"];
}
