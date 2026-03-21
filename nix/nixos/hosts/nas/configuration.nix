{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/profiles/server.nix
    ../../modules/users/cm360.nix

    ./modules/hardware/boot.nix
    ./modules/hardware/filesystems.nix
    ./modules/hardware/impermanence.nix
    ./modules/sops.nix
    ./modules/ssh.nix
    ./modules/users.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    inherit (inputs.secrets.nix) trusted-public-keys;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    nano
    tree
    wget
  ];

  # Fix for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "25.11";
}
