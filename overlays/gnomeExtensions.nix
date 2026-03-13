final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      dash-to-dock = prev.gnomeExtensions.dash-to-dock.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "micheleg";
          repo = "dash-to-dock";
          rev = "0f21b6b9baf504d6e6972e9ea8041240ceadfdc9";
          hash = "sha256-F4k5fUpbqFt86F5ylkX5TznfChN62tzEYBiDO7e81Vw=";
        };
      };
    };
}
