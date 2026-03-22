{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0f8f29f8-b737-4dca-8334-4ef47d899afd";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4549-A01B";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [ ];
}
