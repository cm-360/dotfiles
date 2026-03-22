{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth
    sd-image
  ];

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberry-pi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "tmpfs"
  ];

  sdImage.compressImage = false;
}
