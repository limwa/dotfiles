{pkgs, ...}: let
  pname = "zen";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/1.8.2b/zen-x86_64.AppImage";
    sha256 = "sha256-hZiJ8JLzLhtD1W8DAso3yBAJYhFE+nJEbQJa59AWjnU=";
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install .desktop file
      install -m 444 -D ${appimageContents}/zen.desktop $out/share/applications/${pname}.desktop
      # Install icon
      install -m 444 -D ${appimageContents}/zen.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    '';

    meta = {
      platforms = ["x86_64-linux"];
    };
  }
