{
  pkgs,
  user,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # User-scoped apps
  users.users.${user.login}.packages = with pkgs; [
    affine
    discord
    eclipses.eclipse-modeling
    warp-terminal
    google-chrome
    gthumb
    imagemagick
    insomnia
    jetbrains-toolbox
    slack
    spotify
    vscode
    yt-dlp
    zed-editor
    zoom-us
    zotero
  ];
}
