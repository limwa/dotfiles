{
  user,
  pkgs,
  ...
}: {
  # Set zsh as the default shell for the user.
  users.users.${user.login}.shell = pkgs.zsh;
}
