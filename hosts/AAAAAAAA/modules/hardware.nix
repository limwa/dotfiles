{
  self,
  lib,
  ...
}: let
  nixos-hardware = self.inputs.nixos-hardware;
in {
  imports = [
    "${nixos-hardware}/common/cpu/amd/pstate.nix"
    "${nixos-hardware}/common/gpu/amd"
    "${nixos-hardware}/common/gpu/nvidia/ampere"
    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"
  ];

  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
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
