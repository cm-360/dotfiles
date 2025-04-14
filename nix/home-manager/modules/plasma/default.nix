{
  imports = [
    ./kwin.nix
    ./panels.nix
    ./power.nix
    ./workspace.nix

    ./programs/dolphin.nix
    ./programs/kate.nix
    ./programs/konsole.nix
    ./programs/okular.nix
    ./programs/partitionmanager
  ];

  programs.plasma = {
    enable = true;

    # Fix for https://discuss.kde.org/t/taskbar-icons-disappear/15158
    # https://discuss.kde.org/t/plasma-6-moving-icons-on-panel/11060/11
    configFile."kdedefaults/kdeglobals" = {
      QtQuickRendererSettings = {
        RenderLoop = {
          value = "basic";
          immutable = true;
        };
        SceneGraphBackend = {
          value = "opengl";
          immutable = true;
        };
      };
    };
  };
}
