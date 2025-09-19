{user, ...}: {
  # VirtualBox
  # https://nixos.wiki/wiki/VirtualBox

  # Enable VirtualBox.
  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = ["kvm.enable_virt_at_load=0"];

  # Add vboxusers group to the user.
  users.users.${user.login}.extraGroups = ["vboxusers"];
}
