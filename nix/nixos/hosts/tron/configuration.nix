{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/profiles/laptop.nix

    ../../modules/desktop-plasma6.nix
    ../../modules/service-docker.nix
    ../../modules/service-libvirtd.nix
    ../../modules/service-syncthing.nix
    ../../modules/service-tailscale.nix
    ../../modules/software-steam.nix

    ./modules/boot.nix
    ./modules/hardware-keyboard.nix
    ./modules/hardware-nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  users.users.cm360.extraGroups = [ "docker" ];

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
