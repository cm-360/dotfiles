{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  # https://gerg-l.github.io/spicetify-nix/
  programs.spicetify = {
    enable = true;
    enabledExtensions =
      let
        # Used to be addToQueueTop
        priorityQueue = {
          src = pkgs.fetchFromGitHub {
            owner = "Socketlike";
            repo = "spicetify-extensions";
            rev = "a714f85c1a2024be1d44fbff94bacb79e6102f00";
            hash = "sha256-/Sv/RvP1E9CkXwlePhw2bfo3GBmxMJUHF5UJN0Xhr+I=";
          };
          name = "priority-queue/priority-queue.js";
        };
      in
      with pkgs.spicetifyPackages.extensions;
      [
        adblock
        hidePodcasts
        playingSource
        priorityQueue
        shuffle
      ];
    theme = pkgs.spicetifyPackages.themes.comfy;
    colorScheme = "Spotify";
  };
}
