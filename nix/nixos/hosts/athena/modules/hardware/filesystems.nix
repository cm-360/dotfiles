let
  rootId = "ddd6549a-5043-4094-993a-8723fd0c1ad8";
  bootId = "0D9A-A8B5";
  swapId = "6b4bb93c-1b6b-43a7-a64d-411100ef2060";
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

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/${swapId}";
      randomEncryption.enable = true;
    }
  ];
}
