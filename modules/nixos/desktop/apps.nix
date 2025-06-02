{
  pkgs,
  user,
  ...
}: {
  # Install firefox.
  programs.firefox.enable = true;

  # User-scoped apps
  users.users.${user.login}.packages = with pkgs; [
    (code-cursor.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [pkgs.custom.openssh-permission-patched];
    }))
    discord
    eclipses.eclipse-modeling
    # warp-terminal
    google-chrome
    gthumb
    imagemagick
    insomnia
    jetbrains-toolbox
    libreoffice
    slack
    spotify
    vscode
    yt-dlp
    zed-editor
    zotero
    custom.tableplus
    custom.warp-terminal
  ];
}
