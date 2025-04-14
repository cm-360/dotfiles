{ pkgs, ... }:

{
  programs.konsole = {
    enable = true;

    defaultProfile = "profile1";
    profiles = {
      profile1 = {
        colorScheme = "Relax-Atom-One-Dark";
        font = {
          name = "Fira Code";
          size = 12;
        };
        extraConfig = {
          General = {
            TerminalColumns = 96;
            TerminalRows = 28;
          };
        };
      };
    };

    extraConfig = {
      KonsoleWindow = {
        RememberWindowSize = false;
      };
    };
  };

  home.file.".local/share/konsole/Relax-Konsole.colorscheme".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/L4ki/Relax-Plasma-Themes/71a24c0dfdcd9a8a8887ab5640e6656367f56c23/Relax%20Konsole%20Colorscheme/Relax-Konsole.colorscheme";
    hash = "sha256-JUkJDI/5y8TDWOTXV0xVqoMEdwbyMxAR12gGaSm9Yqg=";
  };
}
