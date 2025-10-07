{user, ...}: {
  home-manager.users.${user.login} = {
    systemd.user.sessionVariables = {
      COMMA_CACHING = "1";
    };
  };
}
