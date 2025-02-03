{
  config,
  lib,
  ...
}: {
  # Nvidia
  # https://nixos.wiki/wiki/Nvidia

  imports = [./.];

  nixpkgs.config.allowUnfree = true;

  # Use the beta NVIDIA drivers. Stable drivers are available too.
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Create specializations for Sync and Reverse Sync modes.
  specialisation = lib.mkIf (config.hardware.nvidia.prime.offload.enable) {
    with-reverse-sync.configuration = {
      hardware.nvidia.prime = {
        reverseSync.enable = true;
      };
    };
  };
}
