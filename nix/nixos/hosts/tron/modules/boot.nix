{
  boot = {
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
  };

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
}
