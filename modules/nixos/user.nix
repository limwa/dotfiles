{
  lib,
  user,
  initialPassword,
  ...
}: {
  users.users.${user.login} = {
    isNormalUser = true;
    description = lib.mkDefault user.displayName;
    extraGroups = ["wheel"];

    initialPassword = lib.mkDefault initialPassword;

    linger = true;
  };
}
