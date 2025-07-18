{ pkgs, ... }:
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

    # Additional modules
    ../../modules/desktop-plasma6.nix
    ../../modules/docker.nix
    ../../modules/firewall-syncthing.nix
    ../../modules/libvirt.nix
    ../../modules/pki-ca-certs.nix
    ../../modules/smart-card.nix
    ../../modules/steam.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
  ];

  networking.firewall.allowedTCPPorts = [
    8080
  ];

  services.tailscale.enable = true;

  users.users.cm360.extraGroups = [
    "docker"
    "libvirtd"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
