{
  user,
  self,
  pkgs,
  ...
}: {
  home-manager.users.${user.login} = {
    # Use direnv to manage environment variables and development environments.
    # https://mynixos.com/home-manager/options/programs.direnv

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      # https://github.com/direnv/direnv/wiki/Customizing-cache-location#human-readable-directories
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';

      # package = self.inputs.direnv-instant.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
