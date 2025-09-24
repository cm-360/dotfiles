# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/profiles/server.nix
    ../../modules/users/cm360.nix

    ../../modules/docker.nix

    ./modules/boot.nix
    ./modules/hardware-nvidia.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
    ];

  time.timeZone = lib.mkForce "UTC";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  virtualisation.docker.liveRestore = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    8096 # Jellyfin
    11434 # Ollama
  ];

  # Fix for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
