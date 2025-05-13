{
  user,
  pkgs,
  ...
}: {
  # Use zsh as the default shell.
  programs.zsh.enable = true;
  users.users.${user.login}.shell = pkgs.zsh;

  home-manager.users.${user.login} = {
    programs.zsh = {
      enable = true;

      shellAliases = {
        dotfiles = "code $HOME/dotfiles";
        nixpkgs = "code /run/current-system/nixpkgs";
        nix = "noglob nix";
      };

      antidote = {
        enable = true;

        plugins = [
          # kubectx and kubens completions
          "ahmetb/kubectx path:completion kind:fpath"

          # Initialize completions (all fpath plugins should be before this)
          "belak/zsh-utils path:completion"

          # OMZ has a lot of dependancies on its lib directory.
          # Load everything in path:lib before loading any plugins
          "ohmyzsh/ohmyzsh path:lib"

          "ohmyzsh/ohmyzsh path:plugins/deno"
          # "ohmyzsh/ohmyzsh path:plugins/docker"
          # "ohmyzsh/ohmyzsh path:plugins/flutter"
          # "ohmyzsh/ohmyzsh path:plugins/gh"
          "ohmyzsh/ohmyzsh path:plugins/kubectl"
          # "ohmyzsh/ohmyzsh path:plugins/asdf"
          "ohmyzsh/ohmyzsh path:plugins/command-not-found"
          "ohmyzsh/ohmyzsh path:plugins/git"
          "ohmyzsh/ohmyzsh path:plugins/magic-enter"
          "ohmyzsh/ohmyzsh path:plugins/pip"
          "ohmyzsh/ohmyzsh path:plugins/python"
          "ohmyzsh/ohmyzsh path:plugins/sudo"
          "ohmyzsh/ohmyzsh path:plugins/z"

          # you should use aliases
          "MichaelAquilina/zsh-you-should-use"

          # syntax highlighting
          "zdharma-continuum/fast-syntax-highlighting kind:defer"

          # p10k prompt theme
          "romkatv/powerlevel10k"
        ];
      };
    };
  };
}
