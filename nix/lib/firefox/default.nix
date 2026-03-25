{
  lib,
  pkgs,
  inputs,
}:
{
  mkBrowserAction = import ./mk-browser-action.nix { inherit lib; };
  mkProfileShortcut = import ./mk-profile-shortcut.nix { inherit pkgs; };

  defaultSettings = import ./default-settings.nix;
  searchEngines = import ./search-engines.nix { inherit pkgs; };
  profiles = import ./profiles { inherit lib pkgs inputs; };
}
