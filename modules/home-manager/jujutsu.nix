{
  user,
  lib,
  ...
}: {
  home-manager.users.${user.login} = {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = lib.mkDefault user.displayName;
          email = lib.mkDefault user.email;
        };
      };
    };
  };
}
