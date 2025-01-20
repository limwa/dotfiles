{
  pkgs,
  wireguard,
  ...
}: {
  # Wireguard
  # https://wiki.nixos.org/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager

  environment.systemPackages = [pkgs.reaction];
  networking.firewall = {
    checkReversePath = "loose";

    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;

    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${wireguard.port} -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${wireguard.port} -j RETURN
    '';

    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${wireguard.port} -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${wireguard.port} -j RETURN || true
    '';
  };
}
