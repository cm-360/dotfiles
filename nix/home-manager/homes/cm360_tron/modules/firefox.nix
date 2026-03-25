{
  pkgs,
  inputs,
  ...
}:
let
  libFirefox = inputs.self.lib.${pkgs.stdenv.hostPlatform.system}.firefox;
in
{
  imports = [
    ../../../modules/firefox/opensc-pkcs11.nix
  ];

  home.packages =
    let
      inherit (libFirefox) mkProfileShortcut;
    in
    [
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

    profiles = with libFirefox.profiles; {
      personal0 = personal0 // {
        id = 0;
      };
      personal1 = personal1 // {
        id = 1;
      };
      work0 = work0 // {
        id = 2;
      };
    };
  };
}
