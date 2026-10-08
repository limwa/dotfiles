{
  user,
  ...
}:
{
  home-manager.users.${user.login} = {
    # Use devenv to manage development environments.
    # https://mynixos.com/home-manager/options/programs.devenv

    programs.devenv = {
      enable = true;
    };
  };
}
