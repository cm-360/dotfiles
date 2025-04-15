{ pkgs, ... }:
let
  buildFirefoxXpiAddon = pkgs.callPackage ./build-xpi-addon.nix { };

  addonsJsonFile = ./addons.json;
  addonsDetails = builtins.fromJSON (builtins.readFile addonsJsonFile);
  addonsPackages = builtins.mapAttrs (_: details: buildFirefoxXpiAddon details) addonsDetails;
in
{
  details = addonsDetails;
  packages = addonsPackages;
}
