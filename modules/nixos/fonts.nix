{pkgs, ...}: {
  # Fonts
  # https://nixos.wiki/wiki/Fonts

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    nerd-fonts.noto
  ];
}
