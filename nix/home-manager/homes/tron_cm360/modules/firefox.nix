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

  mkProfileShortcut =
    name:
    pkgs.stdenv.mkDerivation {
      name = "firefox-${name}-shortcut";

      src = pkgs.writeText "src" ''
        [Desktop Entry]
        Version=1.0
        Terminal=false
        Type=Application
        Name=Firefox - ${name}
        Exec=firefox -P ${name}
        Icon=firefox
      '';

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out/share/applications/
        cat $src >> $out/share/applications/firefox-${name}.desktop
      '';
    };
in
{
  imports = [
    ../../../modules/firefox/opensc-pkcs11.nix
  ];

  home.packages = [
    (mkProfileShortcut "personal0")
    (mkProfileShortcut "personal1")
    (mkProfileShortcut "work0")
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
