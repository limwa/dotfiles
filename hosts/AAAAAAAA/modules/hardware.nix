{
  config,
  self,
  lib,
  pkgs,
  ...
}:
let
  nixos-hardware = self.inputs.nixos-hardware;

  # Internal mic (Realtek ALC257 DMIC, node 0x12): PipeWire spreads the input
  # volume over "Capture" (-17.25..+30 dB) and then "Internal Mic Boost"
  # (+30 dB). Any boost saturates the mic into noise, and Capture above ~+12 dB
  # clips loud speech. So pin the boost to 0 dB and cap Capture at step 39
  # (-17.25 + 39 * 0.75 = +12 dB): 100% slider = the level tested 6/6 in Hex,
  # with no clipping at any slider position.
  acpPathsNoMicBoost = pkgs.runCommand "acp-paths-no-internal-mic-boost" { } ''
    cp -r ${config.services.pipewire.package}/share/alsa-card-profile/mixer/paths $out
    chmod -R u+w $out
    for f in $out/analog-input-internal-mic.conf $out/analog-input-internal-mic-always.conf; do
      sed -i \
        -e '/^\[Element Internal Mic Boost\]/,/^\[/ s/^volume = merge$/volume = zero/' \
        -e '/^\[Element Capture\]/,/^\[/ s/^volume = merge$/volume = merge\nvolume-limit = 39/' \
        "$f"
    done
    # Fail the build if upstream changes the file and the edits no longer apply.
    grep -A4 '^\[Element Internal Mic Boost\]' $out/analog-input-internal-mic.conf | grep -q '^volume = zero$'
    grep -A4 '^\[Element Capture\]' $out/analog-input-internal-mic.conf | grep -q '^volume-limit = 39$'
  '';
in
{
  imports = [
    "${nixos-hardware}/common/cpu/amd"
    "${nixos-hardware}/common/cpu/amd/pstate.nix"
    "${nixos-hardware}/common/gpu/nvidia/ampere"
    "${nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${nixos-hardware}/common/pc/laptop"
    "${nixos-hardware}/common/pc/ssd"
  ];

  boot.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    lenovo-legion-module
  ];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      dynamicBoost.enable = lib.mkDefault true;
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = lib.mkDefault true;

      prime = {
        amdgpuBusId = "PCI:53:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # The ALSA card monitor (and its mixer paths) runs inside WirePlumber.
  systemd.user.services.wireplumber.environment.ACP_PATHS_DIR = "${acpPathsNoMicBoost}";

  # √(1920² + 1080²) px / 15.60 in ≃ 141 dpi
  # services.xserver.dpi = 141;
}
