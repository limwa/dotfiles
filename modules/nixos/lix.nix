{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: let
      lixPackageSets = self.lixPackageSets.override {
        inherit
          (super)
          nix-direnv
          nix-fast-build
          ;
      };
    in {
      inherit
        (lixPackageSets.latest)
        lix
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        ;
    })
  ];

  nix.package = lib.mkForce pkgs.lix;
}
