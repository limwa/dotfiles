{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        cursor = final.callPackage ./cursor {};
        tableplus = final.callPackage ./tableplus {};

        warp-terminal = final.callPackage ./warp-terminal {
          old-warp-terminal = prev.warp-terminal;
        };
      };
    })
  ];
}
