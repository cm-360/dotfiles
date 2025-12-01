{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Common configuration
    ../../modules/profiles/laptop.nix
    ../../modules/users/cm360.nix

    # Boot / Hardware
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/hardware-keyboard.nix
    ./modules/hardware-nvidia.nix
    ./modules/sops.nix

    # Additional modules
    ../../modules/desktop-plasma6.nix
    ../../modules/docker.nix
    ../../modules/firewall-syncthing.nix
    ../../modules/libvirt.nix
    ../../modules/pki-ca-certs.nix
    ../../modules/smart-card.nix
    ../../modules/steam.nix
  ];

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

  users.users.cm360.extraGroups = [
    # "docker"
    "libvirtd"
    # "ydotool"
  ];

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = config.sops.secrets."hashed_passwords/root".path;
  users.users.cm360.hashedPasswordFile = config.sops.secrets."hashed_passwords/cm360".path;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
