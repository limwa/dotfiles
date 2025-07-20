{
  user,
  config,
  ...
}: {
  # VirtualBox
  # https://nixos.wiki/wiki/VirtualBox

  # Enable VirtualBox.
  virtualisation.virtualbox.host = let
    useKvm = config.virtualisation.libvirtd.enable;
  in {
    enable = true;
    enableKvm = useKvm;
    addNetworkInterface = !useKvm;
  };

  # Add vboxusers group to the user.
  users.users.${user.login}.extraGroups = ["vboxusers"];
}
