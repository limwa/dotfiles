{
  pkgs,
  user,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # User-scoped apps
  users.users.${user.login}.packages = with pkgs; [
    discord
    eclipses.eclipse-modeling
    google-chrome
    gthumb
    imagemagick
    insomnia
    jetbrains-toolbox
    slack
    spotify
    vscode
    yt-dlp
    stable.zoom-us
    zotero
  ];
}
