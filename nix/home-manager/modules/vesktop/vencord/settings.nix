# https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts
{
  # Vencord
  useQuickCss = true;
  enableReactDevtools = true;
  frameless = false;
  transparent = true;

  # Notifications
  notifications = {
    timeout = 5000;
    position = "bottom-right";
    useNative = "not-focused";
    logLimit = 50;
  };

  # Plugins
  plugins = import ./plugins.nix;

  # Themes
  themeLinks = [ ];
  enabledThemes = [ ];

  # Updater
  autoUpdate = true;
  autoUpdateNotification = true;

  # Cloud
  cloud = {
    authenticated = false;
    url = "https://api.vencord.dev/";
    settingsSync = false;
    # settingsSyncVersion = 0;
  };

  winCtrlQ = false;
  disableMinSize = false;
  winNativeTitleBar = false;
  eagerPatches = false;
  uiElements = {
    chatBarButtons = { };
    messagePopoverButtons = { };
  };
}
