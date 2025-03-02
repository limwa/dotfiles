{
  nixpkgs.overlays = [
    (final: prev: {
      zen-browser = final.callPackage ./zen-browser {};
    })
  ];
}
