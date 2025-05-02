{ pkgs, ... }:

{
  imports = [
    ./options.nix
    ./packages.nix
    ../security-sudo.nix
    ../service-gpg.nix
    ../service-network.nix
    ../service-ssh.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.cm360 = {
    isNormalUser = true;
    description = "CM360";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };
}
