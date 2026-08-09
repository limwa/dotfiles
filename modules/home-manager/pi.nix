{ user, ... }:
{
  home-manager.users.${user.login} = {
    # Use pi.
    # https://mynixos.com/home-manager/options/programs.pi-coding-agent

    programs.pi-coding-agent = {
      enable = true;

    };
  };
}
