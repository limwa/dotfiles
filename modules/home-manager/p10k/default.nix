{user, ...}: {
  home-manager.users.${user.login} = {
    programs.zsh.initExtra = builtins.readFile ./hook.zsh;
    home.file.".p10k.zsh".source = ./theme.zsh;
  };
}
