{
  fetchurl,
  old-warp-terminal,
}:
old-warp-terminal.overrideAttrs (finalAttrs: prevAttrs: {
  version = "0.2025.04.23.08.11.stable_01";

  src = fetchurl {
    inherit (prevAttrs.src) url;
    sha256 = "sha256-RwKWCU3bldMlS4M+tmfxGE/1d+lMxMPbjdbzpptkmv4=";
  };
})
