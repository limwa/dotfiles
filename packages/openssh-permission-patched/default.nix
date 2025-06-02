{openssh}:
openssh.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [./openssh-nocheckcfg.patch];
})
