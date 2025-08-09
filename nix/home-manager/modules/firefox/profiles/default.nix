{ lib, pkgs, ... }:
let
  addons = import ../addons { inherit lib pkgs; };
  defaultSettings = import ../settings.nix;
  searchEngines = import ../engines.nix { inherit pkgs; };
in
{
  id = 0;

  # about:profiles
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles

  # https://support.mozilla.org/en-US/kb/containers
  # - Colors: blue, turquoise, green, yellow, orange, red, pink,
  #     purple, toolbar
  # - Icons: briefcase, cart, circle, dollar, fence, fingerprint,
  #     gift, vacation, food, fruit, pet, tree, chill
  containers = {
    "Personal" = {
      id = 1;
      color = "blue";
      icon = "fingerprint";
    };
    "School" = {
      id = 2;
      color = "orange";
      icon = "briefcase";
    };
    "Development" = {
      id = 3;
      color = "green";
      icon = "tree";
    };
    "Work" = {
      id = 4;
      color = "red";
      icon = "briefcase";
    };
  };
  containersForce = true;

  # about:addons
  # about:debugging#/runtime/this-firefox
  extensions = {
    packages = with addons.packages; [
      # TODO: replace any with userscripts?
      auto-tab-discard
      better-canvas
      better-darker-docs
      bitwarden
      buster-captcha-solver
      canvasblocker
      clearurls
      darkreader
      disable-page-visibility
      download-with-jdownloader
      fastforward
      indie-wiki-buddy
      librezam
      localcdn
      plasma-integration
      privacy-badger
      return-youtube-dislike
      simple-tab-groups
      stylus
      tampermonkey
      temporary-containers
      terms-of-service-didnt-read
      ublock-origin
    ];

    # TODO: declare settings

    # Temporary Containers
    # - Automatic Mode = false
    # - Prefix = "Temporary "
    # - Container Color = "toolbar"
    # - Container Icon = "chill"
    # - Container Number = "Reuse available numbers"

    # LocalCDN
    # - Don't block Google Fonts on Google pages

    # ~/.mozilla/firefox/<profile>/extension-preferences.json
    # TODO: custom activation script
    # https://mynixos.com/home-manager/option/home.activation
    # preferences = {
    # };
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
        "firefox-addons"
        "openstreetmap"
        "startpage"
        "youtube"

        # Games
        "minecraft-wiki"
        "modrinth-mods"
        "terraria-wiki"
        "calamity-mod-wiki"

        # GitHub
        "github"
        "mdn-web-docs"
        "python3-docs"
        "pypi"
        "svelte"

        # Nix
        "nix-packages"
        "nixos-options"
        "nixos-wiki"
        "home-manager-options"
      ] searchEngines)
      // {
        bing.metaData.hidden = true;
        google.metaData.hidden = true;
      };
  };

  # about:config
  # ~/.mozilla/firefox/<profile>/prefs.js
  # ~/.mozilla/firefox/<profile>/user.js
  settings = defaultSettings // {
    # ----- Appearance -----

    # Built-in themes:
    # - firefox-alpenglow@mozilla.org
    # - firefox-compact-dark@mozilla.org
    # - firefox-compact-light@mozilla.org
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

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
            # Miscellaneous
            actions.terms-of-service-didnt-read
            actions.librezam
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
