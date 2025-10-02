{ buildFirefoxXpiAddon }:
let
  addonsJsonFile = ./addons.json;
  addonsDetails = builtins.fromJSON (builtins.readFile addonsJsonFile);
  packages = builtins.mapAttrs (_: details: buildFirefoxXpiAddon details) addonsDetails;
in
packages
