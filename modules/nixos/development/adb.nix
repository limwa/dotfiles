{
  pkgs,
  user,
  ...
}: {
  services.udev.packages = [pkgs.android-udev-rules];
  users.users.${user.login}.extraGroups = ["adbusers" "plugdev"];

  # Create groups if they don't exist yet
  users.groups.adbusers = {};
  users.groups.plugdev = {};
}
