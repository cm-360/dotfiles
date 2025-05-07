{ lib, pkgs, ... }:
let
  addons = import ../addons { inherit lib pkgs; };
  defaultSettings = import ../settings.nix;
  searchEngines = import ../engines.nix { inherit pkgs; };
in
{
  id = 1;

  # about:addons
  # about:debugging#/runtime/this-firefox
  extensions = {
    packages = with addons.packages; [
      auto-tab-discard
      bitwarden
      clearurls
      darkreader
      download-with-jdownloader
      localcdn
      privacy-badger
      simple-tab-groups
      stylus
      tampermonkey
      temporary-containers
      ublock-origin
    ];
  };

  # ~/.mozilla/firefox/<profile>/search.json.mozlz4
  # Can be extracted using mozlz4a: https://gist.github.com/Tblue/62ff47bef7f894e92ed5
  search = {
    force = true;

    default = "ddg";
    order = [
      "ddg"
      "startpage"
    ];

    engines =
      (lib.getAttrs [
        "firefox-addons"
        "openstreetmap"
        "startpage"
        "youtube"
      ] searchEngines)
      // {
        bing.metaData.hidden = true;
        google.metaData.hidden = true;
      };
  };

  settings = defaultSettings // {
    # ----- Appearance -----

    # Built-in themes:
    # - firefox-alpenglow@mozilla.org
    # - firefox-compact-dark@mozilla.org
    # - firefox-compact-light@mozilla.org
    "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";

    # https://searchfox.org/mozilla-central/source/browser/components/customizableui/CustomizableUI.sys.mjs
    "browser.uiCustomization.state" =
      let
        actions = addons.actions;
      in
      builtins.toJSON {
        placements = {
          nav-bar = [
            # Navigation
            "back-button"
            "forward-button"
            "stop-reload-button"
            "home-button"
            # Address bar
            "customizableui-special-spring1"
            "vertical-spacer"
            "urlbar-container"
            "customizableui-special-spring2"
            # Toolbar
            "downloads-button"
            # "fxa-toolbar-menu-button" # Account
            "unified-extensions-button"
            actions.tampermonkey
            actions.bitwarden
            actions.simple-tab-groups
          ];
          PersonalToolbar = [ "personal-bookmarks" ];
          TabsToolbar = [
            "firefox-view-button"
            "tabbrowser-tabs"
            "new-tab-button"
            "alltabs-button"
            actions.temporary-containers
          ];
          toolbar-menubar = [ "menubar-items" ];
          unified-extensions-area = [
            # Ad-blocking / privacy
            actions.ublock-origin
            actions.privacy-badger
            actions.clearurls
            actions.localcdn
            # Styling
            actions.darkreader
            actions.stylus
          ];
          vertical-tabs = [ ];
          widget-overflow-fixed-list = [ ];
        };

        # Remembers which widgets have been seen before so new widgets
        # can be put in their default location.
        # See: gSeenWidgets in CustomizableUI.sys.mjs
        seen =
          [
            "developer-button"
            "save-to-pocket-button"
          ]
          ++ (
            # Mark all known extension actions as seen
            let
              actionsList = lib.attrsToList actions;
              actionsValues = map (entry: entry.value) actionsList;
            in
            actionsValues
          );

        # Set of area IDs where items have been added, moved, or removed
        # at least once to optimize building default toolbars.
        # See: gDirtyAreaCache in CustomizableUI.sys.mjs
        dirtyAreaCache = [
          "nav-bar"
          "vertical-tabs"
          "PersonalToolbar"
          "toolbar-menubar"
          "TabsToolbar"
          "unified-extensions-area"
        ];

        # Used to migrate customization state for current version.
        # See: currentVersion and kVersion in CustomizableUI.sys.mjs
        currentVersion = 21;

        # TODO: determine meaning/usage
        # newElementCount = 6;
      };

    # Fixes SVG icon colors in the Simple Tab Groups dark theme
    "svg.context-properties.content.enabled" = true;
  };
}
