{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/plasma
    ../../modules/spicetify.nix

    ./modules/stardew-valley.nix
  ];

  home.packages = with pkgs; [
    steamtinkerlaunch

    # Games
    craftland-launcher
    prismlauncher

    # Emulators
    azahar
    cemu
    dolphin-emu
    eden
    melonds
    mgba
    ryubing
  ];

  services.kdeconnect.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
