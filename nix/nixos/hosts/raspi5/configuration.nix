{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/profiles/desktop.nix
    ../../modules/users/cm360.nix

    ../../modules/desktop-plasma6.nix

    ./modules/hardware.nix
    ./modules/sops.nix
    ./modules/users.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  nix.settings = {
    inherit (inputs.secrets.nix) trusted-public-keys;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    lm_sensors
    nano
    tree
    wget
  ];

  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma.desktop";
      User = "cm360";
    };
  };

  services.openssh = {
    enable = true;
    # TODO: setup home-manager for authorized_keys
    settings.PasswordAuthentication = lib.mkForce true;
  };

  system.stateVersion = "26.05";
}
