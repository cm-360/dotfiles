{ pkgs, ... }:
{
  imports = [
    ./gpg.nix
    ./locale.nix
    ./network.nix
    ./ssh.nix
    ./sudo.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Command line utilities
    htop
    git
    tmux
    wget

    # Hardware utilities
    lshw

    exfatprogs

    man-pages
    man-pages-posix
  ];

  programs.zsh.enable = true;
}
