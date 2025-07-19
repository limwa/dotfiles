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
    qemu = {
      package = pkgs.stable.qemu_full;

      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull.fd];
      };
    };
  };

  # Add libvirtd group to the user.
  users.users.${user.login}.extraGroups = ["libvirtd"];
}
