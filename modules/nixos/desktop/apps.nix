{
  pkgs,
  user,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # User-scoped apps
  users.users.${user.login}.packages = with pkgs; [
    code-cursor
    discord
    eclipses.eclipse-modeling
    # warp-terminal
    google-chrome
    gthumb
    imagemagick
    insomnia
    jetbrains-toolbox
    stable.jetbrains.idea-ultimate
    libreoffice
    slack
    spotify
    vscode
    yt-dlp
    stable.zed-editor
    zotero
    custom.tableplus
    custom.warp-terminal
  ];
}
