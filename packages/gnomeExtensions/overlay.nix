final: prev: {
  dash-to-dock = final.callPackage ./dash-to-dock {
    inherit (prev) gnomeExtensions;
  };
}
