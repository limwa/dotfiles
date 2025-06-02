{
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};

        warp-terminal = final.callPackage ./warp-terminal {
          old-warp-terminal = prev.warp-terminal;
        };

        openssh-permission-patched = final.callPackage ./openssh-permission-patched {};
      };
    })
  ];
}
