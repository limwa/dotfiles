{openssh}:
openssh.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [./openssh-nocheckcfg.patch];

  postInstall = ''
    echo "hey" > $out/lmao
  '';
})
