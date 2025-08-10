{
  config,
  pkgs,
  user,
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
    onShutdown = "shutdown";

    nss = {
      enable = true;
      enableGuest = true;
    };

    qemu = {
      package = pkgs.qemu_full;
      swtpm.enable = true;
    };
  };

  # Do not block networking.
  networking.firewall.trustedInterfaces = config.virtualisation.libvirtd.allowedBridges;

  virtualisation.libvirtd.allowedBridges = ["virbr0" "virbr1"];

  # Add libvirtd group to the user.
  users.users.${user.login}.extraGroups = ["libvirtd"];
}
