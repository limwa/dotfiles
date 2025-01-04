{pkgs, ...}: {
  # Linux Kernel
  # https://nixos.wiki/wiki/Linux_kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
