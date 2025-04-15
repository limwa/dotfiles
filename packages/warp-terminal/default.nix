{
  fetchurl,
  old-warp-terminal,
}:
old-warp-terminal.overrideAttrs (finalAttrs: prevAttrs: {
  version = "0.2025.04.09.08.11.stable_02";

  src = fetchurl {
    inherit (prevAttrs.src) url;
    sha256 = "sha256-XSEaTLhOMXls5U/HnP1BVs6pc5esUbbSG2/LF4PY/v0=";
  };
})
