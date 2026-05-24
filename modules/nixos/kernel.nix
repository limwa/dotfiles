{
  pkgs,
  useLatestKernel,
  ...
}:
{
  # Linux Kernel
  # https://nixos.wiki/wiki/Linux_kernel
  boot.kernelPackages = if useLatestKernel then pkgs.linuxPackages_latest else pkgs.linuxPackages;

  boot.kernelPatches = [
    {
      name = "btmtk-accept-too-short-wmt-func-ctrl-events";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/e3ac0d9f1a205f33a43fba3b79ef74d2f604c78b.patch?full_index=1";
        hash = "sha256-DE6im1PmLWFYRk2QtfCWXfBzBCMT4fyUgufDhUn0wL8=";
      };
    }
  ];
}
