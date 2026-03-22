{
  lib,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "tmpfs"
  ];

  sdImage.compressImage = false;
}
