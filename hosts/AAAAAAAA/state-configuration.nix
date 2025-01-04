{user, ...}: let
  stateVersion = "24.05";
in {
  system.stateVersion = stateVersion;
  home-manager.users.${user.login}.home.stateVersion = stateVersion;
}
