# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/profiles/server.nix

    ../../modules/service-docker.nix
    ../../modules/service-libvirtd.nix
    ../../modules/service-tailscale.nix

    ./modules/boot.nix
  ];

  networking.hostName = "orion";

  time.timeZone = lib.mkForce "UTC";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
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
