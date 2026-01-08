{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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
                  # Prevent WirePlumber from mapping the "boost" control to
                  # the policy volume; these property names depend on your card
                  "api.alsa.soft-mixer" = true;
                };
              };
            }
          ];
        };
      };
    };
  };
}
