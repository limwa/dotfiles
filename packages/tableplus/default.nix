{
  stdenv,
  fetchurl,
  appimageTools,
  lib,
}: let
  pname = "tableplus";
  version = "1.2.6-260";

  src = fetchurl {
    url =
      if stdenv.hostPlatform.system == "x86_64-linux"
      then "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage"
      else if stdenv.hostPlatform.system == "aarch64-linux"
      then "https://tableplus.com/release/linux/arm64/TablePlus-aarch64.AppImage"
      else throw "This derivation for TablePlus is not supported on ${stdenv.hostPlatform.system}";

    hash = "sha256-4HIPkWqpIcyycpqs3ELcQZUlgmcXeHxdsJ6gS8YmIAg=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    meta = {
      description = "Database management made easy";
      homepage = "https://tableplus.com/";
      license = lib.licenses.unfree;
      platforms = with lib.platforms; (x86_64 ++ aarch64);
    };

    extraInstallCommands = ''
      install -D -m444 ${appimageContents}/usr/share/applications/tableplus-appimage.desktop $out/share/applications/tableplus-appimage.desktop
      install -D -m444 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/tableplus.png $out/share/icons/hicolor/256x256/apps/tableplus.png

      substituteInPlace $out/share/applications/tableplus-appimage.desktop \
        --replace-fail 'Icon=tableplus' "Icon=$out/share/icons/hicolor/256x256/apps/tableplus.png"
    '';
  }
