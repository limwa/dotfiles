{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};
      };
    })
  ];
}
