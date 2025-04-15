{
  self,
  system,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        tableplus = final.callPackage ./tableplus {};
        zen-browser = final.callPackage ./zen-browser {};
      };

      donteatoreo = import self.inputs.nixpkgs-donteatoreo {
        inherit system;
        config.allowUnfree = true;
      };
    })
  ];
}
