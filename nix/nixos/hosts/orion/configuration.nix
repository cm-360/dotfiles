{ pkgs, ... }:
{
  imports = [
    # Common configuration
    ../../modules/profiles/server.nix
    ../../modules/users/cm360.nix

    # Boot / Hardware
    ./hardware-configuration.nix
    ./modules/boot.nix

    # Additional modules
    ../../modules/docker.nix
    ../../modules/libvirt.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.tailscale.enable = true;

  # Fix for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  users.users.cm360.extraGroups = [
    "libvirtd"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
