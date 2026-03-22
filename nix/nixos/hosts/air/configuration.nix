{
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/profiles/laptop.nix
    ../../modules/users/cm360.nix

    ../../modules/desktop-plasma6.nix
    ../../modules/firewall-syncthing.nix

    ./modules/hardware/boot.nix
    ./modules/hardware/filesystems.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    inherit (inputs.secrets.nix) trusted-public-keys;
  };

  # https://blog.quarkslab.com/reverse-engineering-broadcom-wireless-chipsets.html
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/broadcom-sta/default.nix
  nixpkgs.config.allowInsecurePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-sta"
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-sta"
    ];

  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
