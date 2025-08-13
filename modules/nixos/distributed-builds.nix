{pkgs, ...}: {
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "LIMA";
      sshUser = "remotebld";
      sshKey = "/root/.ssh/remotebld";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = ["kvm" "big-parallel"];
    }
  ];
}
