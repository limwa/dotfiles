{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};
        zen-browser = final.callPackage ./zen-browser {};

        warp-terminal = final.callPackage ./warp-terminal {
          old-warp-terminal = prev.warp-terminal;
        };
      };
    })
  ];
}
