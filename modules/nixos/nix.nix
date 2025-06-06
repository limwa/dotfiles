{pkgs, ...}: {
  # Create a symlink to the latest nixpkgs of the flake
  # See: https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/18
  system.extraSystemBuilderCmds = ''
    ln -sv ${pkgs.path} $out/nixpkgs
  '';

  nix = {
    # Enable flakes
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = ["@wheel"];

      # Build binaries from source if a connection to the cache is not possible.
      fallback = true;
    };

    # Use the nixpkgs of the flake (for `nix-shell` for instance)
    nixPath = ["nixpkgs=/run/current-system/nixpkgs"];

    # Enable the Nix garbage collector, and collect garbage every day.
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };

    # Optimize the Nix store by deduplicating store paths.
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
  };
}
