{ lib, pkgs, ... }:

{
  imports = [
    # ./modules/gpg.nix
    # ./modules/ssh.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home.packages = with pkgs; [
    # GUI apps
    bitwarden-desktop
    feishin # Jellyfin music client
    jellyfin-media-player
    spotify
    tor-browser
    vesktop # Discord
    vlc

    # Games
    # prismlauncher
    # osu-lazer-bin
    # ryujinx

    # Command line utilities
    bat
    fastfetch
    gum
    ripgrep
    tree
    zoxide
  ];

  programs.ssh = {
    enable = true;

    addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;

  services.gpg-agent = {
    enable = true;

    enableZshIntegration = true;
  };

  xsession.numlock.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.activation = {
    updateDesktopIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      nix-shell -p desktop-file-utils --run "update-desktop-database -v ~/.local/share/applications"
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cm360/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
