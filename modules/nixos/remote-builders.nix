{pkgs, ...}: {
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "lima";
      sshUser = "remotebld";
      sshKey = "/root/.ssh/remotebld";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = ["kvm" "big-parallel"];
    }
  ];
}
