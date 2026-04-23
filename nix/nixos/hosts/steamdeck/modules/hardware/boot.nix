{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"

      # usb keyfile
      "uas"
      "usbcore"
      "vfat"
      "nls_cp437"
      "nls_iso8859_1"
    ];
    kernelModules = [ "kvm-amd" ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "5"; # horizontal mode
      };

      timeout = 3;
    };

    plymouth.enable = true;

    initrd.systemd.enable = true;
    initrd.systemd.mounts = [
      {
        what = "/dev/disk/by-partlabel/keys";
        where = "/keys";
        options = "ro";
        type = "vfat";
      }
    ];

    initrd.luks.devices."cryptroot" = {
      device = "/dev/disk/by-uuid/43b170fb-d566-4049-be77-eb5f70d42794";
      keyFile = "/keys/steamdeck.key";
      allowDiscards = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
}
