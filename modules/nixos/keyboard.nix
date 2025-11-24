{usePortugueseKeyboard, ...}: {
  # Configure console keymap
  console.keyMap =
    if usePortugueseKeyboard
    then "pt-latin1"
    else "us";

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "ibus";
}
