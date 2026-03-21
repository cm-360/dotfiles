{ inputs, ... }:
{
  imports = [
    # TODO: dynamic system, infinite recursion
    inputs.distro-grub-themes.nixosModules."x86_64-linux".default
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };

    plymouth.enable = true;

    initrd.luks.devices."cryptroot" = {
      device = "/dev/disk/by-label/NixOS-luks";
      allowDiscards = true;
    };
  };

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}
