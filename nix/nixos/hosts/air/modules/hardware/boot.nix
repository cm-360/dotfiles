{
  config,
  inputs,
  ...
}:
{
  imports = [
    # TODO: infinite recursion
    # inputs.distro-grub-themes.nixosModules.${pkgs.stdenv.hostPlatform.system}.default
    inputs.distro-grub-themes.nixosModules."x86_64-linux".default
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [
      "kvm-intel"
      "wl"
    ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

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

    initrd.luks.devices."luks-adb981aa-5c4f-4234-98e6-274d92608bba".device =
      "/dev/disk/by-uuid/adb981aa-5c4f-4234-98e6-274d92608bba";
  };

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}
