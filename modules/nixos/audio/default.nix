{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };
}
