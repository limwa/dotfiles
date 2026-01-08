{
  # PipeWire
  # https://nixos.wiki/wiki/PipeWire

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  boot.extraModprobeConfig = ''
    options snd_hda_intel model=auto
    options snd_hda_intel dmic_detect=0"
  '';

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "95-disable-mic-boost" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "~alsa_card.*";
                  "device.vendor.id" = "0x1022";
                  "device.product.id" = "0x15e3";
                }
              ];
              actions = {
                update-props = {
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
