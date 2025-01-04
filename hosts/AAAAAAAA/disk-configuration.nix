{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "efi";
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };
            swap = {
              priority = 2;
              label = "swap";
              size = "36G"; # EDIT - swap-size must be greater than your RAM size
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            nixos = {
              priority = 3;
              label = "nixos";
              end = "-0";
              content = {
                type = "btrfs";
                mountpoint = "/";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/home" = {
                    mountOptions = ["compress=zstd:2"];
                    mountpoint = "/home";
                  };
                  "/nix" = {
                    mountOptions = ["compress=zstd:2" "noatime"];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
