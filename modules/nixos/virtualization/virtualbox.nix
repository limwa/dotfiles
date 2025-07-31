{user, ...}: {
  # VirtualBox
  # https://nixos.wiki/wiki/VirtualBox

  # Enable VirtualBox.
  virtualisation.virtualbox.host.enable = true;

  # Add vboxusers group to the user.
  users.users.${user.login}.extraGroups = ["vboxusers"];
}
