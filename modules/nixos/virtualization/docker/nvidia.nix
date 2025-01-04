{
  imports = [./.];

  # Enable Nvidia GPU usage in Docker containers.
  # https://nixos.wiki/wiki/Docker#GPU_Pass-through_.28Nvidia.29

  hardware.nvidia-container-toolkit.enable = true;
}
