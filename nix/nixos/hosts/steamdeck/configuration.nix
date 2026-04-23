{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.jovian-nixos.nixosModules.default

    ../../modules/profiles/desktop.nix
    ../../modules/users/cm360.nix

    ../../modules/desktop-plasma6.nix
    ../../modules/steam.nix

    ./modules/hardware/boot.nix
    ./modules/hardware/filesystems.nix
    ./modules/hardware/impermanence.nix
    ./modules/sops.nix
    ./modules/users.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    inherit (inputs.secrets.nix) trusted-public-keys;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "steam-jupiter-unwrapped"
      "steam"
      "steamdeck-hw-theme"
    ];

  nixpkgs.overlays = [
    inputs.craftland.overlays.default
  ];

  jovian = {
    devices.steamdeck.enable = true;

    steam = {
      enable = true;
      autoStart = true;

      user = "cm360";
      desktopSession = "plasma";
    };

    # https://github.com/Jovian-Experiments/Jovian-NixOS/issues/460#issuecomment-2599835660
    # Settings > System > Enable Developer Mode = true
    # Settings > Developer > CEF Remote Debugging = true
    decky-loader.enable = true;
  };

  environment.systemPackages = with pkgs; [ ];

  security.rtkit.enable = true;

  services.displayManager.sddm.wayland.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "26.05";
}
