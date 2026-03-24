{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        # fractal = final.callPackage ./fractal {};
        tableplus = final.callPackage ./tableplus {};
        gnomeExtensions = import ./gnomeExtensions/overlay.nix final prev;
      };
    })
  ];
}
