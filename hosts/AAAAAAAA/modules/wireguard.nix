{config, ...}: {
  networking.wg-quick.interfaces.wg0.configFile = config.age.secrets.wg-AAAAAAAA.path;
}
