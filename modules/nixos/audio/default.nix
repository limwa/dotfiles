{ pkgs, ... }:
let
  # TEMPORARY: PipeWire with an unreleased LE Audio fix from master
  # (9b7cd1b "bluez5: only clear BAP endpoints during BAP codec switching").
  # Without it, switching a dual-mode (A2DP + LE Audio) device to a BAP
  # profile can fail with org.freedesktop.DBus.Error.UnknownMethod.
  # Drop this once nixpkgs ships a PipeWire release that contains it.
  pipewire = pkgs.pipewire.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/pipewire-bluez5-only-clear-bap-endpoints.patch ];
  });
in
{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    package = pipewire;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      # The Bluetooth (spa-bluez5) plugin runs inside WirePlumber and is loaded
      # from the PipeWire it was built against, so rebuild it against ours.
      package = pkgs.wireplumber.override { inherit pipewire; };
    };
  };
}
