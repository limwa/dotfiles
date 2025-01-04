{user, ...}: {
  home-manager.users.${user.login} = {
    # Use bat instead of cat.
    # https://github.com/sharkdp/bat
    programs.bat.enable = true;

    # Setup shell alias.
    programs.zsh.shellAliases.cat = "bat --paging=never --style=plain";
  };
}
