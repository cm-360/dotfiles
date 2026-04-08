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
  customAddons = inputs.self.packages.${system}.firefoxAddons;

  # TODO: replace any with userscripts?
  extensions =
    (with ryceeAddons; [
      auto-tab-discard
      better-canvas
      better-darker-docs
      bitwarden
      buster-captcha-solver
      canvasblocker
      clearurls
      darkreader
      download-with-jdownloader
      fastforwardteam
      indie-wiki-buddy
      localcdn
      plasma-integration
      privacy-badger
      return-youtube-dislikes
      simple-tab-groups
      stylus
      temporary-containers
      terms-of-service-didnt-read
      ublock-origin
      violentmonkey
    ])
    ++ (with customAddons; [
      disable-page-visibility
      librezam
    ]);
in
{
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
  };
  containersForce = true;

  # about:addons
  # about:debugging#/runtime/this-firefox
  extensions = {
    packages = extensions;

    # TODO: allow in private browsing
    # https://github.com/nix-community/home-manager/issues/5433#issuecomment-2848841865

    # TODO: declare extension settings
    # settings = {
    #   "addon@darkreader.org".settings = {
    #     private_browsing = true;
    #   };
    #   "uBlock0@raymondhill.net".settings = {
    #     private_browsing = true;
    #   };
    # };

    # Temporary Containers
    # - Automatic Mode = false
    # - Prefix = "Temporary "
    # - Container Color = "toolbar"
    # - Container Icon = "chill"
    # - Container Number = "Reuse available numbers"

    # LocalCDN
    # - Don't block Google Fonts on Google pages

    # Bitwarden
    # - Show autofill on form fields

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
        "astroneer-wiki"
        "minecraft-wiki"
        "modrinth-mods"
        "stardew-wiki"
        "terraria-wiki"
        "calamity-mod-wiki"

        # Development
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
        "mynixos"
      ] libFirefox.searchEngines)
      // {
        bing.metaData.hidden = true;
        google.metaData.hidden = true;
        perplexity.metaData.hidden = true;
      };
  };

  # about:config
  # ~/.mozilla/firefox/<profile>/prefs.js
  # ~/.mozilla/firefox/<profile>/user.js
  settings = libFirefox.defaultSettings // {
    # ----- Appearance -----

    # Built-in themes:
    # - firefox-alpenglow@mozilla.org
    # - firefox-compact-dark@mozilla.org
    # - firefox-compact-light@mozilla.org
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

    "browser.toolbars.bookmarks.visibility" = "always"; # "always", "newtab", "never"

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
          # Customization
          (mkBrowserAction ryceeAddons.darkreader)
          (mkBrowserAction ryceeAddons.violentmonkey)
          (mkBrowserAction ryceeAddons.stylus)
          # Miscellaneous
          (mkBrowserAction ryceeAddons.terms-of-service-didnt-read)
          (mkBrowserAction customAddons.librezam)
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
