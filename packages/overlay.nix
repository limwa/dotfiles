{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};
        warp-terminal = final.callPackage ./warp-terminal {};
        zen-browser = final.callPackage ./zen-browser {};
      };
    })
  ];
}
