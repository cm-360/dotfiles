{ lib, pkgs, ... }:
let
  defaultProfile = import ../../../modules/firefox/profiles/default.nix { inherit lib pkgs; };
  secondaryProfile = import ../../../modules/firefox/profiles/secondary.nix { inherit lib pkgs; };
in
{
  imports = [
    ../../../modules/firefox/opensc-pkcs11.nix
  ];

  # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      # Fixes https://github.com/nix-community/home-manager/issues/1586
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    };

    profiles = {
      default = defaultProfile;
      secondary = secondaryProfile;
    };
  };
}
