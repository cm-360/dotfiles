{
  lib,
  pkgs,
  ...
}:
let
  browserAction = import ../lib/browser-action.nix { inherit lib; };

  defaultSettings = import ../settings.nix;
  searchEngines = import ../engines.nix { inherit pkgs; };

  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
  ryceeAddons = pkgs.firefox-addons;

  extensions = with ryceeAddons; [
    bitwarden
    clearurls
    darkreader
    localcdn
    privacy-badger
    ublock-origin
  ];
in
{
  # about:addons
  # about:debugging#/runtime/this-firefox
  extensions = {
    packages = extensions;
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
        # General
        "startpage"

        # Development
        "github"
        "mdn-web-docs"
        "python3-docs"

        # Nix
        "nix-packages"
        "nixos-options"
        "nixos-wiki"
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
    "extensions.activeThemeID" = "{bbc344a9-8a64-460a-895c-1aa98f84a319}";

    # TODO: themes require installation?

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
          (browserAction ryceeAddons.bitwarden)
        ];
        PersonalToolbar = [ "personal-bookmarks" ];
        TabsToolbar = [
          "firefox-view-button"
          "tabbrowser-tabs"
          "new-tab-button"
          "alltabs-button"
        ];
        toolbar-menubar = [ "menubar-items" ];
        unified-extensions-area = [
          # Ad-blocking / privacy
          (browserAction ryceeAddons.ublock-origin)
          (browserAction ryceeAddons.privacy-badger)
          (browserAction ryceeAddons.clearurls)
          (browserAction ryceeAddons.localcdn)
          # Styling
          (browserAction ryceeAddons.darkreader)
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
      ++ (map browserAction extensions);

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
