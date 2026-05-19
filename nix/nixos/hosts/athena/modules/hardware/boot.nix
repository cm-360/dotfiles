{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
      # usb keyfile
      "uas"
      "usbcore"
      "vfat"
      "nls_cp437"
      "nls_iso8859_1"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    initrd.systemd.enable = true;
    initrd.systemd.mounts = [
      {
        what = "/dev/disk/by-uuid/5FDE-3098";
        where = "/key";
        options = "ro";
        type = "vfat";
      }
    ];

    initrd.luks.devices."cryptroot" = {
      device = "/dev/disk/by-uuid/9d8ec3e6-0b8c-445f-8691-105d1bb0404e";
      keyFile = "/key/keyfile";
      allowDiscards = true;
    };

    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "pool0" ];
    zfs.forceImportRoot = false;
  };

  # ZFS
  networking.hostId = "799d4f0f";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}
