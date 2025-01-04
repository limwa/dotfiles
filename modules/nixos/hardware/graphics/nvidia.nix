{config, ...}: {
  # Nvidia
  # https://nixos.wiki/wiki/Nvidia

  imports = [./.];

  nixpkgs.config.allowUnfree = true;

  # Use the beta NVIDIA drivers. Stable drivers are available too.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}
