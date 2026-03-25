{
  lib,
  pkgs,
  inputs,
}:
let
  mkImport =
    name:
    import ./${name}.nix {
      inherit lib pkgs inputs;
    };

  profileNames = [
    "personal0"
    "personal1"
    "work0"
  ];
in
builtins.listToAttrs (
  map (name: {
    inherit name;
    value = mkImport name;
  }) profileNames
)
