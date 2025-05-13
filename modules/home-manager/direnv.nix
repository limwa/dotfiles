{user, ...}: {
  home-manager.users.${user.login} = {
    # Use direnv to manage environment variables and development environments.
    # https://mynixos.com/home-manager/options/programs.direnv

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Enable direnv for zsh.
      enableZshIntegration = true;

      # Enable direnv for fish.
      enableFishIntegration = true;
    };
  };
}
