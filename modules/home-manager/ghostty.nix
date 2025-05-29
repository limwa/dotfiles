{
  user,
  config,
  ...
}: {
  home-manager.users.${user.login} = {
    programs.ghostty = {
      enable = true;
    };
  };
}
