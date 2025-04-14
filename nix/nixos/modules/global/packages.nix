{ pkgs, ... }:

{
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
