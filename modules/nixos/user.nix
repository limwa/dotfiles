{
  lib,
  user,
  initialPassword,
  pkgs,
  ...
}: {
  # Use fish as the default shell.
  programs.fish.enable = true;

  users.users.${user.login} = {
    isNormalUser = true;
    description = lib.mkDefault user.displayName;
    extraGroups = ["wheel"];
    shell = pkgs.fish;

    initialPassword = lib.mkDefault initialPassword;
  };
}
