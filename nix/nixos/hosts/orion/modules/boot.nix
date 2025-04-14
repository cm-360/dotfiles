{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

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

    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };

  # Required for ZFS
  networking.hostId = "c40352c9";
}
