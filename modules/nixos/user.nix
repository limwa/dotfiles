{
  lib,
  user,
  initialPassword,
  pkgs,
  ...
}: {
  # Use zsh as the default shell.
  programs.zsh.enable = true;

  users.users.${user.login} = {
    isNormalUser = true;
    description = lib.mkDefault user.displayName;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;

    initialPassword = lib.mkDefault initialPassword;
  };
}
