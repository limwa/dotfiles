{usePortugueseKeyboard, ...}: {
  # Configure console keymap
  console.keyMap =
    if usePortugueseKeyboard
    then "pt-latin1"
    else "us";

  # GTK requires an input method to support accented characters
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.waylandFrontend = true;
  };
}
