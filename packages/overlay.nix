{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        fractal = final.callPackage ./fractal {};
        tableplus = final.callPackage ./tableplus {};
      };
    })
  ];
}
