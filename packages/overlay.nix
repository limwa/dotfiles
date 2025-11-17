{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        fractal = final.callPackage ./fractal {};
        gnomeExtensions.media-controls = final.callPackage ./gnomeExtensions/media-controls {};
        tableplus = final.callPackage ./tableplus {};
      };
    })
  ];
}
