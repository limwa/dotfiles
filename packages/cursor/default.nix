{
  lib,
  newScope,
  openssh,
  appimageTools,
  code-cursor,
}: let
  scope = lib.makeScope newScope (overrides: {
    openssh = overrides.callPackage ./openssh {inherit openssh;};

    appimageTools =
      appimageTools
      // {
        wrapType2 = {extraPkgs ? pkgs: [], ...} @ args:
          appimageTools.wrapType2 (
            args
            // {
              extraPkgs = pkgs: extraPkgs pkgs ++ [overrides.openssh];
            }
          );
      };

    code-cursor = overrides.callPackage code-cursor.override {};
  });
in
  scope.code-cursor
