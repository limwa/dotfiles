{user, ...}: let
in {
  home-manager.users.${user.login} = {
    # Delta
    # https://mynixos.com/home-manager/options/programs.delta
    programs.delta = {
      enable = true;

      # Enable delta for diff viewing.
      enableGitIntegration = true;
    };
  };
}
