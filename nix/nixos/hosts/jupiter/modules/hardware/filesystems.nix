let
  rootId = "0a80d881-172c-4785-8659-8d1855117a47";
  bootId = "AF8A-E911";
  # swapId = "";
in
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/${rootId}";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/${bootId}";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/${rootId}";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress-force=zstd:1"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/${rootId}";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress-force=zstd"
        "noatime"
      ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/${rootId}";
      fsType = "btrfs";
      options = [
        "subvol=@persist"
        "compress-force=zstd"
      ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/${rootId}";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress-force=zstd:1"
      ];
      neededForBoot = true;
    };

    "/tmp" = {
      device = "none";
      fsType = "tmpfs";
    };
  };

  # swapDevices = [
  #   {
  #     device = "/dev/disk/by-partuuid/${swapId}";
  #     randomEncryption.enable = true;
  #   }
  # ];
}
