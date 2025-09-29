{
  lib,
  pkgs,
  buildFirefoxXpiAddon,
  ...
}:
let
  importProfile = path: import path { inherit lib pkgs buildFirefoxXpiAddon; };

  personalProfile0 = importProfile ../../../modules/firefox/profiles/personal0.nix;
  personalProfile1 = importProfile ../../../modules/firefox/profiles/personal1.nix;
  workProfile0 = importProfile ../../../modules/firefox/profiles/work0.nix;

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
      personal0 = personalProfile0 // {
        id = 0;
      };
      personal1 = personalProfile1 // {
        id = 1;
      };
      work0 = workProfile0 // {
        id = 2;
      };
    };
  };
}
