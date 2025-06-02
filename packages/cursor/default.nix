{code-cursor}:
code-cursor.override (old: {
  appimageTools =
    old.appimageTools
    // {
      wrapType2 = {extraPkgs ? pkgs: [], ...} @ args:
        old.appimageTools.wrapType2 (args
          // {
            extraPkgs = pkgs: let
              openssh = pkgs.callPackage ./openssh {};
            in
              extraPkgs pkgs ++ [openssh];
          });
    };
})
