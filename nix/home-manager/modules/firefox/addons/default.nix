{ lib, pkgs, ... }:
let
  buildFirefoxXpiAddon = pkgs.callPackage ./build-xpi-addon.nix { };

  addonsJsonFile = ./addons.json;
  addonsDetails = builtins.fromJSON (builtins.readFile addonsJsonFile);
  addonsPackages = builtins.mapAttrs (_: details: buildFirefoxXpiAddon details) addonsDetails;

  browserAction =
    addonInfo:
    let
      sanitizedId = builtins.replaceStrings [ " " ] [ "_" ] (
        builtins.toString (builtins.split "[^a-z0-9\-]" (lib.toLower addonInfo.addonId))
      );
    in
    sanitizedId + "-browser-action";

  addonActions = builtins.mapAttrs (name: details: (browserAction details)) addonsDetails;
in
{
  details = addonsDetails;
  packages = addonsPackages;
  actions = addonActions;
}
