{ pkgs, ... }:

let
  # Read transformed colors
  transformColors = import ./transform-colors.nix { inherit pkgs; };
  colors = builtins.readFile "${transformColors}/transformed_colors.txt";

  # Function to parse each line and generate a configuration entry
  parseLine =
    line:
    let
      parts = pkgs.lib.splitString "=" line;
    in
    {
      key = builtins.elemAt parts 0;
      value = builtins.elemAt parts 1;
    };

  # Parse transformed filesystem colors
  lines = pkgs.lib.filter (line: line != "") (pkgs.lib.splitString "\n" colors);
  colorEntries = map parseLine lines;

  # Final Plasma partitionmanager configuration entries
  partitionManagerConfig = builtins.listToAttrs (
    map (entry: {
      name = entry.key;
      value = {
        # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.configFile._name_._name_._name_.value
        value = entry.value;
      };
    }) colorEntries
  );
in
{
  programs.plasma.configFile."partitionmanagerrc" = {
    "KDE Partition Manager" = partitionManagerConfig;
  };
}
