{
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user.login} = {
    # Use gh to manage GitHub repositories.
    # https://mynixos.com/home-manager/options/programs.gh

    programs.gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
      };

      extensions = with pkgs; [
        gh-dash
        gh-notify
      ];
    };
  };
}
