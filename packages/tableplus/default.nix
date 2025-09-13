{
  stdenv,
  fetchurl,
  appimageTools,
  lib,
}:
assert stdenv.hostPlatform.system == "x86_64-linux";
  appimageTools.wrapType2 rec {
    pname = "tableplus";
    version = "1.2.8-266";

    src = fetchurl {
      url = "https://files.tableplus.com/linux/x64/266/TablePlus-x64.AppImage";
      hash = "sha256-3qMFdjtwnGyGTZqHgKRA9RKH4cQgOJ9RsS/0hzH+tKU=";
    };

    extraInstallCommands = let
      appimageContents = appimageTools.extract {
        inherit pname version src;
      };
    in ''
      install -D -m444 ${appimageContents}/usr/share/applications/tableplus-appimage.desktop $out/share/applications/tableplus.desktop
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
