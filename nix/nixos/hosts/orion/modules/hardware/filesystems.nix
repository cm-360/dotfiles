{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/712b0af3-c39d-4df1-a69f-89465c02f32d";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D007-3610";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/pool1" = {
      device = "pool1";
      fsType = "zfs";
      options = [ "nofail" ];
    };
  };

  swapDevices = [ ];
}
