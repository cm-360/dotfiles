{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenvNoCC.mkDerivation {
  pname = "transform-filesystem-colors";
  version = "1.0";

  # Download the partitionmanager.kcfg file
  # https://github.com/KDE/partitionmanager
  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/KDE/partitionmanager/392cc0b1135f02f84e9a05cadc256a9468378dfb/src/partitionmanager.kcfg";
    hash = "sha256-bmiqxq7q/rzYQzpkTcrjvzemXkW/yXeZlZ+K7WLEwms=";
  };

  dontUnpack = true;

  buildInputs = [ pkgs.python3 ];

  pythonScript = ./transform_colors.py;

  installPhase = ''
    cp $src partitionmanager.kcfg
    cp $pythonScript transform_colors.py
    mkdir -p $out
    python3 transform_colors.py > $out/transformed_colors.txt
  '';

  meta = with pkgs.lib; {
    description = "Transform default filesystem colors from partitionmanager.kcfg";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
