{ pkgs }:
let
  mkProfileShortcut =
    name:
    pkgs.stdenv.mkDerivation {
      name = "firefox-${name}-shortcut";

      src = pkgs.writeText "src" ''
        [Desktop Entry]
        Version=1.0
        Terminal=false
        Type=Application
        Name=Firefox - ${name}
        Exec=firefox -P ${name}
        Icon=firefox
      '';

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out/share/applications/
        cat $src >> $out/share/applications/firefox-${name}.desktop
      '';
    };
in
mkProfileShortcut
