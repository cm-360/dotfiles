{
  lib,
  pkgs,
  inputs,
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  libFirefox = inputs.self.lib.${system}.firefox;
  inherit (libFirefox) mkBrowserAction;

  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
  ryceeAddons = inputs.rycee-firefox-addons.packages.${system};

  extensions = with ryceeAddons; [
    auto-tab-discard
    bitwarden
    clearurls
    darkreader
    download-with-jdownloader
    localcdn
    privacy-badger
    simple-tab-groups
    stylus
    temporary-containers
    ublock-origin
    violentmonkey
  ];
in
{
  # about:addons
  # about:debugging#/runtime/this-firefox
  extensions.packages = extensions;

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
      ] libFirefox.searchEngines)
      // {
        bing.metaData.hidden = true;
        google.metaData.hidden = true;
        perplexity.metaData.hidden = true;
      };
  };

  settings = libFirefox.defaultSettings // {
    # ----- Appearance -----

    # Built-in themes:
    # - firefox-alpenglow@mozilla.org
    # - firefox-compact-dark@mozilla.org
    # - firefox-compact-light@mozilla.org
    "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";

    # https://searchfox.org/mozilla-central/source/browser/components/customizableui/CustomizableUI.sys.mjs
    "browser.uiCustomization.state" = builtins.toJSON {
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
          (mkBrowserAction ryceeAddons.violentmonkey)
          (mkBrowserAction ryceeAddons.bitwarden)
          (mkBrowserAction ryceeAddons.simple-tab-groups)
        ];
        PersonalToolbar = [ "personal-bookmarks" ];
        TabsToolbar = [
          "firefox-view-button"
          "tabbrowser-tabs"
          "new-tab-button"
          "alltabs-button"
          (mkBrowserAction ryceeAddons.temporary-containers)
        ];
        toolbar-menubar = [ "menubar-items" ];
        unified-extensions-area = [
          # Ad-blocking / privacy
          (mkBrowserAction ryceeAddons.ublock-origin)
          (mkBrowserAction ryceeAddons.privacy-badger)
          (mkBrowserAction ryceeAddons.clearurls)
          (mkBrowserAction ryceeAddons.localcdn)
          # Styling
          (mkBrowserAction ryceeAddons.darkreader)
          (mkBrowserAction ryceeAddons.stylus)
        ];
        vertical-tabs = [ ];
        widget-overflow-fixed-list = [ ];
      };

      # Remembers which widgets have been seen before so new widgets
      # can be put in their default location.
      # See: gSeenWidgets in CustomizableUI.sys.mjs
      seen = [
        "developer-button"
        "save-to-pocket-button"
      ]
      # Mark all installed extension actions as seen
      ++ (map mkBrowserAction extensions);

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
