{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

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
                };
              };
            }
          ];
        };
      };
    };
  };
}
