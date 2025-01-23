{
  pkgs,
  useLatestKernel,
  ...
}: {
  # Linux Kernel
  # https://nixos.wiki/wiki/Linux_kernel
  boot.kernelPackages =
    if useLatestKernel
    then pkgs.linuxPackages_latest
    else pkgs.linuxPackages;
}
