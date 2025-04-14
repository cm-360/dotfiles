{
  lib,
  stdenvNoCC,
  fetchurl,
  ...
}:
let
  # Based on https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix
  buildFirefoxXpiAddon =
    {
      pname,
      version,
      addonId,
      url,
      sha256,
      meta,
      ...
    }:
    stdenvNoCC.mkDerivation {
      name = "${pname}-${version}";

      src = fetchurl { inherit url sha256; };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';

      inherit meta;
    };
in
buildFirefoxXpiAddon
