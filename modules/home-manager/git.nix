{
  user,
  pkgs,
  lib,
  ...
}: let
in {
  home-manager.users.${user.login} = {
    # Git
    # https://mynixos.com/home-manager/options/programs.git
    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      userName = lib.mkDefault user.displayName;
      userEmail = lib.mkDefault user.email;

      # Enable delta for diff viewing.
      delta.enable = true;

      # Enable Git LFS.
      lfs.enable = true;

      ignores = [
        ".idea"
        ".direnv"
      ];

      signing = {
        key = lib.mkDefault user.signingKey;
        signByDefault = true;
      };

      extraConfig = {
        commit.verbose = true; # Show diff of changes in commit message editor.
        diff.colorMoved = "default"; # Highlight moved lines in diff.
        diff.algorithm = "histogram"; # Use histogram diff algorithm.
        help.autocorrect = "prompt"; # Prompt for spelling correction in git commands.
        init.defaultBranch = "main"; # Set default branch name.
        merge.conflictstyle = "zdiff3"; # Use zdiff3 as the default conflict style.
        pull.rebase = true; # Use rebase instead of merge when pulling.
        push.autoSetupRemote = true; # Automatically set tracking branch for remotes.
        rerere.enabled = true; # Record conflict resolutions for future merges.

        credential = {
          # FEUP's network works really poorly with SSH, so I use HTTPS instead.
          "https://git.fe.up.pt".helper = "libsecret";
          "https://gitlab.up.pt".helper = "libsecret";
        };
      };
    };
  };
}
