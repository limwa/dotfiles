{
  config,
  lib,
  useOpenNvidiaDrivers,
  ...
}: {
  # Nvidia
  # https://nixos.wiki/wiki/Nvidia

  imports = [./.];

  nixpkgs.config.allowUnfree = true;

  # Use Wayland by default.
  services.displayManager.defaultSession = lib.mkDefault "gnome";

  # Use the beta NVIDIA drivers. Stable drivers are available too.
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = useOpenNvidiaDrivers;
  };

  # Create specializations for Sync mode.
  # specialisation = lib.mkIf (config.hardware.nvidia.prime.offload.enable) {
  #   with-sync.configuration = {
  #     # Use X11 for better handling of the display.
  #     services.displayManager.defaultSession = lib.mkForce "gnome-xorg";
  #
  #     hardware.nvidia = {
  #       prime = {
  #         offload.enable = lib.mkForce false;
  #         sync.enable = lib.mkForce true;
  #       };
  #
  #       powerManagement.finegrained = lib.mkForce false;
  #     };
  #   };
  # };
}
