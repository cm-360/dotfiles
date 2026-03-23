{ pkgs, ... }:
{
  imports = [
    ../../../modules/chromium/opensc-pkcs11.nix
  ];

  programs.chromium = {
    enable = true;

    package = pkgs.ungoogled-chromium;

    commandLineArgs = [
      "--disable-gpu" # Fixes graphical issues on Wayland
    ];
  };
}
