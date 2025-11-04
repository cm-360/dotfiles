{ lib, pkgs, ... }:
{
  imports = [
    ./modules/chromium.nix
    ./modules/firefox.nix
    ./modules/input-devices.nix

    ../../modules/desktop.nix
    ../../modules/direnv.nix
    ../../modules/gpg.nix
    ../../modules/plasma
    ../../modules/spicetify.nix
    ../../modules/vscodium.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
      "osu-lazer-bin"
      "spotify"
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6" # TODO: determine dependent and remove once upgraded
  ];

  nixpkgs.overlays = [
    (import ../../../overlays/obsidian-wayland-fix.nix)
    (import ../../../overlays/vesktop-discord-icon.nix)
  ];

  home.packages = with pkgs; [
    # GUI apps
    bitwarden-desktop
    blender
    dbeaver-bin
    element-desktop
    feishin # Jellyfin music client
    gcolor3 # Color picker
    # gimp
    inkscape
    kdePackages.filelight
    kdePackages.kdenlive
    krita
    libreoffice-qt6-fresh
    obsidian
    obs-studio
    picard
    qalculate-qt
    qbittorrent
    thunderbird-latest
    tor-browser
    vesktop # Discord
    vlc

    # Games
    craftland-launcher
    dolphin-emu
    prismlauncher
    osu-lazer-bin
    ryubing # https://git.ryujinx.app/ryubing/ryujinx
    # suyu # https://git.suyu.dev/

    # Command line utilities
    bat
    ccze # Log colorizer, https://github.com/cornet/ccze
    csvlens
    eza # ls replacement https://github.com/eza-community/eza
    fastfetch
    ffmpeg
    fx # JSON viewer/processor https://github.com/antonmedv/fx
    git-lfs
    jq # JSON processor
    p7zip
    pandoc
    ripgrep
    tree
    texliveSmall
    yt-dlp
    xxd
    zoxide # Smarter cd https://github.com/ajeetdsouza/zoxide

    # Development utilities
    # android-studio
    android-tools

    # Languages
    bash-language-server
    nil # Nix language server
    nixfmt-rfc-style
    go
    gopls # Go language server
    prettypst # Typst formatter, https://github.com/antonWetzel/prettypst
    python313
    python313Packages.python-lsp-server
    python313Packages.ruff # Python formatter
    python313Packages.uv # Python package manager
    shfmt # Shell formatter
    tinymist # Typst language server
    typst
    typescript-language-server
    vscode-langservers-extracted # CSS/ESLint/HTML/JSON/Markdown
  ];

  programs.nix-index-database.comma.enable = true;

  services.kdeconnect.enable = true;
  services.mpris-discord-rpc.enable = true;
  services.syncthing.enable = true;

  # https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
  systemd.user.tmpfiles.rules = [
    "L %h/.config/Ryujinx - - - - /data/cm360/Games/Consoles/Switch/Ryujinx"
    "L %h/.local/share/dolphin-emu - - - - /data/cm360/Games/Consoles/Wii/Dolphin"
    "L %h/.local/share/PrismLauncher - - - - /data/cm360/Games/PC/Minecraft/PrismLauncher"
    "L %h/.local/share/suyu - - - - /data/cm360/Games/Consoles/Switch/Yuzu"
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    #
    # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at one of:
  # - ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # - ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # - /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = { };

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
