{user, ...}: {
  home-manager.users.${user.login} = {
    programs.fish = {
      enable = true;
      generateCompletions = true;

      shellAliases = {
        dotfiles = "code $HOME/dotfiles";
        nixpkgs = "code /run/current-system/nixpkgs";
        #nix = "noglob nix";
      };
    };

    programs.starship = {
      enable = true;
      enableTransience = true;
      enableFishIntegration = true;
    };
  };
}
