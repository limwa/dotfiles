{
  fetchurl,
  old-warp-terminal,
}:
old-warp-terminal.overrideAttrs (finalAttrs: prevAttrs: {
  version = "0.2025.05.07.08.12.stable_02";

  src = fetchurl {
    inherit (prevAttrs.src) url;
    sha256 = "sha256-uEaQecj5h6if5Hc7BjuXxxVO+SqOYE/xop08ujQFgGg=";
  };
})
