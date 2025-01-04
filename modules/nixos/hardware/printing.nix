{
  lib,
  pkgs,
  useEpsonDrivers,
  ...
}: let
  defaultDrivers = with pkgs; [gutenprint];
in {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers =
      defaultDrivers
      ++ lib.optionals useEpsonDrivers (
        with pkgs; [epson-escpr epson-escpr2]
      );
  };
}
