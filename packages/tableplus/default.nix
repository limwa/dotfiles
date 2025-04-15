{
  stdenv,
  fetchurl,
  appimageTools,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "tableplus";
  version = "1.2.6-264";

  src = fetchurl {
    url =
      if stdenv.hostPlatform.system == "x86_64-linux"
      then "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage"
      else if stdenv.hostPlatform.system == "aarch64-linux"
      then "https://tableplus.com/release/linux/arm64/TablePlus-aarch64.AppImage"
      else throw "This derivation for TablePlus is not supported on ${stdenv.hostPlatform.system}";

    hash = "sha256-4HIPkWqpIcyycpqs3ELcQZUlgmcXeHxdsJ6gS8YmIAg=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extract {
      inherit pname version src;
    };
  in ''
    install -D -m444 ${appimageContents}/usr/share/applications/tableplus-appimage.desktop $out/share/applications/tableplus-appimage.desktop
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/tableplus.png $out/share/icons/hicolor/256x256/apps/tableplus.png
  '';

  meta = {
    description = "Database management made easy";
    homepage = "https://tableplus.com/";
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
