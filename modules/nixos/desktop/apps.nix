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
    warp-terminal
    gnome-boxes
    google-chrome
    gthumb
    imagemagick
    insomnia
    jetbrains-toolbox
    jetbrains.idea-ultimate
    libreoffice
    slack
    spotify
    vscode
    yt-dlp
    zed-editor
    zotero
    custom.tableplus
  ];
}
