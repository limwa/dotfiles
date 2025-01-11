{user, ...}: let
in {
  home-manager.users.${user.login} = {
    programs = {
      # SSH
      # https://mynixos.com/home-manager/options/programs.ssh
      ssh = {
        enable = true;
        matchBlocks = {
          # Allow VPS access on firewalled networks.
          vps = {
            host = "vps.limwa.pt";
            port = 2222;
          };
        };
      };
    };
  };
}
