{ pkgs, ... }:
let
  buildFirefoxXpiAddon = pkgs.callPackage ./build-xpi-addon.nix { };

  addonsJsonFile = ./addons.json;
  addonsData = builtins.fromJSON (builtins.readFile addonsJsonFile);
in
builtins.mapAttrs (_: addonData: buildFirefoxXpiAddon addonData) addonsData
