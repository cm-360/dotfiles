{ lib, ... }:
let
  browserAction =
    addon:
    let
      sanitizedId = builtins.replaceStrings [ " " ] [ "_" ] (
        builtins.toString (builtins.split "[^a-z0-9\-]" (lib.toLower addon.addonId))
      );
    in
    sanitizedId + "-browser-action";
in
browserAction
