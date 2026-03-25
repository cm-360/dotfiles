{ buildFirefoxXpiAddon }:
let
  addonsDetails = builtins.fromJSON (builtins.readFile ./addons.json);
  packages = builtins.mapAttrs (_: details: buildFirefoxXpiAddon details) addonsDetails;
in
packages
