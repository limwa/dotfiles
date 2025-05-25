{
  fetchurl,
  old-warp-terminal,
}:
old-warp-terminal.overrideAttrs (finalAttrs: prevAttrs: {
  version = "0.2025.05.21.08.11.stable_01";

  src = fetchurl {
    inherit (prevAttrs.src) url;
    hash = "sha256-iM1d1NBIFLbuCGk8k80HEKMWSCHl2QXbusE8N1mIS94=";
  };
})
