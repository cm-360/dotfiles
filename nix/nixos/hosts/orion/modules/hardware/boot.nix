{
  boot = {
    initrd.availableKernelModules = [
      "vmd"
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernelParams = [
      # TODO remove? https://www.reddit.com/r/VFIO/comments/ks7ve3/alternative_to_efifboff/
      "video=efifb:off"
      # Enable IOMMU in passthrough mode
      "intel_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      # GPU
      "vfio-pci.ids=10de:2488,10de:228b"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };

  # Required for ZFS
  # head -c 8 /etc/machine-id
  networking.hostId = "c40352c9";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}
