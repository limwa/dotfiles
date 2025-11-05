{fractal}:
fractal.overrideAttrs (old: {
  patches =
    old.patches
    ++ [
      ./increase-codegen-units.patch
    ];
})
