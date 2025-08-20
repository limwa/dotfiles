{
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "LIMA";
      sshUser = "remotebld";
      sshKey = "/root/.ssh/remotebld";
      system = "x86_64-linux";
      supportedFeatures = ["kvm" "big-parallel"];
      protocol = "ssh-ng";
      maxJobs = 16;
    }
  ];
}
