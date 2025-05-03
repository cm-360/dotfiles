{ pkgs, ... }:
{
  # https://gerg-l.github.io/spicetify-nix/
  programs.spicetify = {
    enable = true;
    enabledExtensions = with pkgs.spicetifyPackages.extensions; [
      adblock
      hidePodcasts
      shuffle
      addToQueueTop
      playingSource
    ];
    theme = pkgs.spicetifyPackages.themes.comfy;
    colorScheme = "Spotify";
  };
}
