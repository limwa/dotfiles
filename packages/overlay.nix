{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};
        zen-browser = final.callPackage ./zen-browser {};
      };
    })
  ];
}
