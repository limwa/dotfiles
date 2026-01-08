{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "95-disable-mic-boost" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {"node.name" = "~alsa_input.*.analog-stereo";}
              ];
              actions = {
                update-props = {
                };
              };
            }
          ];
        };
      };
    };
  };
}
