{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bibata-cursors
    fira-code
    papirus-icon-theme
  ];

  programs.plasma = {
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";

      # System: /run/current-system/sw/share/color-schemes
      # User: ~/.local/share/color-schemes
      colorScheme = "RelaxDarkColor";

      cursor = {
        size = 24;
        theme = "Bibata-Modern-Classic";
      };
      iconTheme = "Papirus-Dark";

      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/";
    };

    fonts = {
      fixedWidth = {
        family = "Fira Code";
        pointSize = 12;
      };
    };
  };

  home.file.".local/share/color-schemes/RelaxDarkColor.colors".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/L4ki/Relax-Plasma-Themes/aca3bf6ee5630ddf6062b0bd66afde50aec4bb97/Relax%20Colorschemes/RelaxDarkColor.colors";
    hash = "sha256-1lkcmoRxX+Q3JRGxcCv8eF4j1QKSPN5molXdNQs1HnQ=";
  };
}
