{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./state-configuration.nix

    ../../modules/nixos/agenix.nix
    ../../modules/nixos/audio/bluetooth.nix
    ../../modules/nixos/hardware/graphics/amdgpu.nix
    ../../modules/nixos/hardware/graphics/nvidia.nix
    ../../modules/nixos/hardware/thunderbolt.nix
    ../../modules/nixos/virtualization/docker/btrfs.nix
    ../../modules/nixos/virtualization/docker/nvidia.nix
    ../../modules/nixos/secureboot/enforce.nix
    ./modules/hardware.nix
  ];

  networking.hostName = "AAAAAAAA";
}
