{
  self,
  lib,
  ...
}: let
  nixos-hardware = self.inputs.nixos-hardware;
in {
  imports = [
    "${nixos-hardware}/common/cpu/amd/pstate.nix"
    "${nixos-hardware}/common/cpu/amd/zenpower.nix"
    "${nixos-hardware}/common/gpu/nvidia/ampere"
    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"
  ];

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    dynamicBoost.enable = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    powerManagement.enable = lib.mkDefault true;
    powerManagement.finegrained = lib.mkDefault true;

    prime = {
      amdgpuBusId = "PCI:53:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # √(1920² + 1080²) px / 15.60 in ≃ 141 dpi
  # services.xserver.dpi = 141;
}
