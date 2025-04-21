{
  fetchurl,
  old-warp-terminal,
}:
old-warp-terminal.overrideAttrs (finalAttrs: prevAttrs: {
  version = "0.2025.04.16.08.11.stable_02";

  src = fetchurl {
    inherit (prevAttrs.src) url;
    sha256 = "sha256-+/0PA8Z/IbgHNtk78v4d3cw0G8Kk1MQ+gN16/8nKmGg=";
  };
})
