{config, ...}: {
  # CCache
  # https://nixos.wiki/wiki/CCache

  programs.ccache.enable = true;

  nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];

  nixpkgs.overlays = [
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR="${config.programs.ccache.cacheDir}"
          export CCACHE_UMASK=007
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
    /*
      (
      self: super: let
        withCachedStdenv = drv:
          drv.override (prev: {
            stdenv = self.ccacheStdenv.override {
              inherit (prev) stdenv;
            };
          });
      in {
        libreoffice = super.libreoffice.override (prev: {
          unwrapped = withCachedStdenv prev.unwrapped;
        });
      }
    )
    */
  ];
}
