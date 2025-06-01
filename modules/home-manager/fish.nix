{
  user,
  pkgs,
  ...
}: {
  # Use fish as the default shell.
  programs.fish.enable = true;
  users.users.${user.login}.shell = pkgs.fish;

  home-manager.users.${user.login} = {
    programs.fish = {
      enable = true;
      generateCompletions = true;

      shellAliases = {
        dotfiles = "code $HOME/dotfiles";
        nixpkgs = "code /run/current-system/nixpkgs";
        #nix = "noglob nix";
      };

      shellInit = ''
        set fish_greeting
      '';

      plugins = with pkgs.fishPlugins; [
        z
        plugin-git
        autopair
        puffer
        sponge
        done
        pure
        fish-you-should-use
        colored-man-pages
        plugin-sudope
        fzf-fish
      ];
    };
  };
}
