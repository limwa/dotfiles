{
  user,
  self,
  pkgs,
  ...
}: {
  home-manager.users.${user.login} = {
    # Use direnv to manage environment variables and development environments.
    # https://mynixos.com/home-manager/options/programs.direnv

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      package = self.inputs.direnv-instant.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
