{usePortugueseKeyboard, ...}: {
  # Configure console keymap
  console.keyMap =
    if usePortugueseKeyboard
    then "pt-latin1"
    else "us";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout =
      if usePortugueseKeyboard
      then "pt,us"
      else "us,pt";
    xkb.options = "grp:win_space_toggle";
  };
}
