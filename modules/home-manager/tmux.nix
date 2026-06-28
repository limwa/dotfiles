{ user, ... }:
{
  home-manager.users.${user.login} = {
    # Use tmux terminal multiplexer.
    programs.tmux.enable = true;
  };
}
