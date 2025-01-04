{
  pkgs,
  user,
  ...
}: {
  services.udev.packages = [pkgs.android-udev-rules];
  users.users.${user.login}.extraGroups = ["adbusers" "plugdev"];
}
