{user, ...}: let
in {
  home-manager.users.${user.login} = {
    # SSH
    # https://mynixos.com/home-manager/options/programs.ssh
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        # Use some default SSH options.
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        # Allow GitHub SSH on firewalled networks.
        github = {
          host = "github.com";
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
        };
      };
    };

    # Allow SSH config to be used inside FHS environments.
    # https://github.com/nix-community/home-manager/issues/322
    home.file.".ssh/config" = {
      target = ".ssh/_config";
      onChange = "cat ~/.ssh/_config > ~/.ssh/config && chmod 400 ~/.ssh/config";
    };
  };
}
