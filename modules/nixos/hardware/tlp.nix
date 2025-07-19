{pkgs, ...}: {
  # Create a specialisation for TLP.
  specialisation.with-tlp.configuration = {
    # Enable TLP.
    services.tlp = {
      enable = true;
      package = pkgs.stable.tlp;
    };

    # Disable Power Profiles Daemon.
    services.power-profiles-daemon.enable = false;
  };
}
