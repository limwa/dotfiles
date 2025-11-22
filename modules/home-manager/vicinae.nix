{user, ...}: {
  home-manager.users.${user.login} = {
    # Use vicinae.
    # https://home-manager-options.extranix.com/?query=vicinae&release=master

    programs.vicinae = {
      enable = true;
    };
  };
}
