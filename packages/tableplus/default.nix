{
  stdenv,
  fetchurl,
  appimageTools,
  lib,
}: let
  url =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage"
    else if stdenv.hostPlatform.system == "aarch64-linux"
    then "https://tableplus.com/release/linux/arm64/TablePlus-aarch64.AppImage"
    else throw "This derivation for TablePlus is not supported on ${stdenv.hostPlatform.system}";
in
  appimageTools.wrapType2 {
    pname = "tableplus";
    version = "1.2.6-260";

    src = fetchurl {
      inherit url;
      sha256 = "sha256-4HIPkWqpIcyycpqs3ELcQZUlgmcXeHxdsJ6gS8YmIAg=";
    };

    meta = {
      description = "Database management made easy";
      homepage = "https://tableplus.com/";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
    };

    extraPkgs = pkgs:
      with pkgs; [
        e2fsprogs
        fontconfig.lib
        freetype
        fribidi
        harfbuzz
        kdePackages.wayland
        libgcc.lib
        libgpg-error
        libz
        xorg.libX11
        xorg.libxcb
      ];
  }
