{
  appimageTools,
  fetchurl,
}: let
in
  appimageTools.wrapType2 {
    pname = "warp-terminal";
    version = "v0.2025.04.09.08.11.stable_02";

    src = fetchurl {
      url = "https://releases.warp.dev/stable/v0.2025.04.09.08.11.stable_02/Warp-x86_64.AppImage";
      sha256 = "sha256-h5JiMfxyk7V54Gwy99oeOG9ClVWWbY/eb5oP/0ml86Y=";
    };
  }
