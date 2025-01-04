{pkgs, ...}: {
  # Secure Boot (tools required for instalation)
  # https://nixos.wiki/wiki/Secure_Boot

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
}
