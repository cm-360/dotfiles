{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/profiles/laptop.nix
    ../../modules/users/cm360.nix

    ../../modules/desktop-plasma6.nix
    ../../modules/docker.nix
    ../../modules/firewall-syncthing.nix
    ../../modules/libvirt.nix
    ../../modules/pki-ca-certs.nix
    ../../modules/smart-card.nix
    ../../modules/steam.nix

    ./modules/hardware/boot.nix
    ./modules/hardware/filesystems.nix
    ./modules/hardware/keyboard.nix
    ./modules/hardware/nvidia.nix
    ./modules/sops.nix
    ./modules/users.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "steam"
      "steam-unwrapped"
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # https://github.com/ReimuNotMoe/ydotool
  # programs.ydotool.enable = true;

  services.tailscale.enable = true;

  networking.firewall.allowedTCPPorts = [
    8080
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
