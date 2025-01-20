# Agenix
# https://github.com/ryantm/agenix
{
  self,
  system,
  secrets,
  ...
}: let
  agenix = self.inputs.agenix;
in {
  # Enable agenix and install CLI
  imports = [agenix.nixosModules.default];
  environment.systemPackages = [agenix.packages.${system}.default];

  # Agenix setup is simpler if sshd is enabled.
  services.openssh.enable = true;

  age.secrets = builtins.listToAttrs (
    map (secret: {
      name = secret;
      value = {
        file = ../../secrets/${secret}.age;
      };
    })
    secrets
  );
}
