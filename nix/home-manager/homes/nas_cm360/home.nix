{ config, ... }:
{
  imports = [
    ../../modules/comma.nix

    ./modules/sops.nix
  ];

  home.username = "cm360";
  home.homeDirectory = "/home/${config.home.username}";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
