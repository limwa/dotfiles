{
  pkgs,
  user,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # Accept Android SDK licenses
  nixpkgs.config.android_sdk.accept_license = true;

  # User-scoped apps
  users.users.${user.login}.packages = with pkgs; [
    android-studio-full
    code-cursor
    discord
    eclipses.eclipse-modeling
    element-web
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
