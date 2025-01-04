{
  imports = [./.];

  # Use Btrfs as the Docker storage driver.
  # https://mynixos.com/nixpkgs/option/virtualisation.docker.storageDriver

  virtualisation.docker.storageDriver = "btrfs";
}
