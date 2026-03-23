final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      dash-to-dock = prev.gnomeExtensions.dash-to-dock.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "micheleg";
          repo = "dash-to-dock";
          rev = "69c6ee5c7669b0a3b0077467cdbbcf3b39ddc44a";
          hash = "sha256-/zQpiMDGLsBtPSn1KV2CLqb3cFMJo34qrrJW0UXNRlo=";
        };
      };
    };
}
