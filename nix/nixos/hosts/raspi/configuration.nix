{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi3;
  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "btrfs"
    "tmpfs"
  ];

  sdImage.compressImage = false;

  services.openssh.enable = true;

  # TODO: set a user password first
  security.sudo.wheelNeedsPassword = false;

  users.users."cm360" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    lm_sensors
    nano
    tree
    wget
  ];

  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "aarch64-linux";
}
