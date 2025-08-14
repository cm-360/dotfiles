{ lib, buildFirefoxXpiAddon, ... }:
let
  addonsJsonFile = ./addons.json;
  addonsDetails = builtins.fromJSON (builtins.readFile addonsJsonFile);
  packages = builtins.mapAttrs (_: details: buildFirefoxXpiAddon details) addonsDetails;

  browserAction =
    addon:
    let
      sanitizedId = builtins.replaceStrings [ " " ] [ "_" ] (
        builtins.toString (builtins.split "[^a-z0-9\-]" (lib.toLower addon.addonId))
      );
    in
    sanitizedId + "-browser-action";
in
{
  inherit browserAction packages;
}
