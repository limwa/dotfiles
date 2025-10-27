{
  imports = [./.];

  # Enable Nvidia GPU usage in Podman containers.
  hardware.nvidia-container-toolkit.enable = true;
}
