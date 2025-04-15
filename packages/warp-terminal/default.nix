{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "warp-terminal";
  version = "v0.2025.04.09.08.11.stable_02";

  src = fetchurl {
    url = "https://releases.warp.dev/stable/v0.2025.04.09.08.11.stable_02/Warp-x86_64.AppImage";
    sha256 = "sha256-h5JiMfxyk7V54Gwy99oeOG9ClVWWbY/eb5oP/0ml86Y=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extract {
      inherit pname version src;
    };
  in ''
    install -D -m444 ${appimageContents}/usr/share/applications/dev.warp.Warp.desktop $out/share/applications/dev.warp.Warp.desktop
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/16x16/apps/dev.warp.Warp.png $out/share/icons/hicolor/16x16/apps/dev.warp.Warp.png
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/32x32/apps/dev.warp.Warp.png $out/share/icons/hicolor/32x32/apps/dev.warp.Warp.png
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/64x64/apps/dev.warp.Warp.png $out/share/icons/hicolor/64x64/apps/dev.warp.Warp.png
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/128x128/apps/dev.warp.Warp.png $out/share/icons/hicolor/128x128/apps/dev.warp.Warp.png
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/dev.warp.Warp.png $out/share/icons/hicolor/256x256/apps/dev.warp.Warp.png
    install -D -m444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/dev.warp.Warp.png $out/share/icons/hicolor/512x512/apps/dev.warp.Warp.png

    substituteInPlace $out/share/applications/dev.warp.Warp.desktop \
      --replace-fail 'Exec=warp %U' "Exec=${pname} %U"
  '';

  meta = {
    description = "The intelligent terminal.";
    homepage = "https://warp.dev";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
  };
}
