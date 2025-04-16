{ pkgs, lib, ... }:
let
  addons = pkgs.callPackage ../../../modules/firefox/addons { };
in
{
  # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  # https://brainfucksec.github.io/firefox-hardening-guide
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    };

    # about:profiles
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles
    profiles = {
      default = {
        id = 0;

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
          packages = with addons.packages; [
            bitwarden
            clearurls
            darkreader
            localcdn
            plasma-integration
            privacy-badger
            simple-tab-groups
            stylus
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
            "Startpage"
          ];

          engines =
            let
              param = name: value: {
                inherit name;
                inherit value;
              };
            in
            {
              # TODO: Test various Searx instances: https://searx.space/

              # ----- General -----

              bing.metaData.hidden = true;
              google.metaData.hidden = true;

              "Firefox Add-ons" = {
                # https://addons.mozilla.org/en-US/firefox/opensearch.xml
                urls = [ { template = "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}"; } ];
                icon = "https://addons.mozilla.org/favicon.ico";
                metaData.hideOneOffButton = true;
                updateInterval = 24 * 60 * 60 * 1000; # daily
                definedAliases = [ "@addons" ];
              };
              "OpenStreetMap" = {
                # https://www.openstreetmap.org/assets/osm-42b7b3fbcee2193e455a773db6cd3d34a2f48ca94547fed54901dd9d8307b02b.xml
                description = "Search for a place in OpenStreetMap";
                urls = [ { template = "https://www.openstreetmap.org/search?query={searchTerms}"; } ];
                icon = "https://www.openstreetmap.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@osm" ];
              };
              "Startpage" = {
                urls = [
                  {
                    template = "https://www.startpage.com/sp/search";
                    params = [
                      (param "language" "english")
                      (param "query" "{searchTerms}")
                    ];
                  }
                  {
                    template = "https://www.startpage.com/osuggestions?q={searchTerms}";
                    type = "application/x-suggestions+json";
                  }
                ];
                icon = "https://www.startpage.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                definedAliases = [ "@startpage" ];
              };
              youtube = {
                # https://www.youtube.com/opensearch?locale=en_US
                name = "YouTube";
                description = "Search for videos on YouTube";
                urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
                icon = "https://www.youtube.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                definedAliases = [ "@youtube" ];
              };

              # ----- Games -----

              "Minecraft Wiki" = {
                # https://minecraft.wiki/opensearch_desc.php
                urls = [
                  { template = "https://minecraft.wiki/w/Special:Search?search={searchTerms}"; }
                  {
                    template = "https://minecraft.wiki/api.php";
                    params = [
                      (param "action" "opensearch")
                      (param "namespace" "0|10000|10002|10004|10006")
                      (param "maxage" "600")
                      (param "smaxage" "600")
                      (param "uselang" "content")
                      (param "search" "{searchTerms}")
                    ];
                    type = "application/x-suggestions+json";
                  }
                ];
                icon = "https://minecraft.wiki/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@minecraft" ];
              };
              "Modrinth Mods" = {
                # https://modrinth.com/opensearch.xml
                description = "Search for mods on Modrinth, the open source modding platform.";
                urls = [ { template = "https://modrinth.com/mods?q={searchTerms}"; } ];
                icon = "https://modrinth.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@modrinth" ];
              };
              "Terraria Wiki" = {
                # https://terraria.wiki.gg/rest.php/v1/search
                urls = [
                  { template = "https://terraria.wiki.gg/wiki/Special:Search?search={searchTerms}"; }
                  {
                    template = "https://terraria.wiki.gg/api.php";
                    params = [
                      (param "action" "opensearch")
                      (param "namespace" "0")
                      (param "search" "{searchTerms}")
                    ];
                    type = "application/x-suggestions+json";
                  }
                ];
                icon = "https://terraria.wiki.gg/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@terraria" ];
              };
              "Calamity Mod Wiki" = {
                # https://calamitymod.wiki.gg/rest.php/v1/search
                urls = [
                  { template = "https://calamitymod.wiki.gg/wiki/Special:Search?search={searchTerms}"; }
                  {
                    template = "https://calamitymod.wiki.gg/api.php";
                    params = [
                      (param "action" "opensearch")
                      (param "namespace" "0")
                      (param "maxage" "28800")
                      (param "smaxage" "28800")
                      (param "uselang" "content")
                      (param "search" "{searchTerms}")
                    ];
                    type = "application/x-suggestions+json";
                  }
                ];
                icon = "https://calamitymod.wiki.gg/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@calamity" ];
              };

              # ----- Development -----

              "GitHub" = {
                # https://github.com/opensearch.xml
                urls = [ { template = "https://github.com/search?q={searchTerms}&ref=opensearch"; } ];
                icon = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@github" ];
              };
              "MDN Web Docs" = {
                # https://developer.mozilla.org/opensearch.xml
                urls = [ { template = "https://developer.mozilla.org/search?q={searchTerms}"; } ];
                icon = "https://developer.mozilla.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@mdn" ];
              };
              "Python 3 Docs" = {
                # https://docs.python.org/3/_static/opensearch.xml
                urls = [ { template = "https://docs.python.org/3/search.html?q={searchTerms}"; } ];
                icon = "https://docs.python.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@python" ];
              };
              "PyPI" = {
                # https://pypi.org/opensearch.xml
                urls = [ { template = "https://pypi.org/search/?q={searchTerms}"; } ];
                icon = "https://pypi.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@pypi" ];
              };
              "Svelte" = {
                # https://svelte.dev/opensearch.xml
                urls = [ { template = "https://svelte.dev/search?q={searchTerms}"; } ];
                icon = "https://svelte.dev/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # daily
                metaData.hideOneOffButton = true;
                definedAliases = [ "@svelte" ];
              };

              # ----- Nix -----

              "Nix Packages" = {
                # https://search.nixos.org/desc-search-packages.xml
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      (param "type" "packages")
                      (param "channel" "unstable")
                      (param "query" "{searchTerms}")
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nixpkgs" ];
              };
              "NixOS Options" = {
                # https://search.nixos.org/desc-search-options.xml
                urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                metaData.hideOneOffButton = true;
                definedAliases = [ "@nixopts" ];
              };
              "NixOS Wiki" = {
                # https://nixos.wiki/opensearch_desc.php
                urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                metaData.hideOneOffButton = true;
                definedAliases = [ "@nixwiki" ];
              };
            };
        };

        # about:config
        # ~/.mozilla/firefox/<profile>/prefs.js
        # ~/.mozilla/firefox/<profile>/user.js
        settings = {
          # Thank-you to:
          # - https://github.com/arkenfox/user.js/blob/master/user.js
          # - https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
          # - https://github.com/Misterio77/nix-config/blob/2097eac0158e1604bd52c918728729850c6fe746/home/gabriel/features/desktop/common/firefox.nix

          # ----- Appearance -----

          # Built-in themes:
          # - firefox-alpenglow@mozilla.org
          # - firefox-compact-dark@mozilla.org
          # - firefox-compact-light@mozilla.org
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

          # https://searchfox.org/mozilla-central/source/browser/components/customizableui/CustomizableUI.sys.mjs
          "browser.uiCustomization.state" =
            let
              browserAction =
                addonInfo:
                let
                  sanitizedId = builtins.replaceStrings [ " " ] [ "_" ] (
                    builtins.toString (builtins.split "[^a-z0-9\-]" (lib.toLower addonInfo.addonId))
                  );
                in
                sanitizedId + "-browser-action";

              addonActions = builtins.mapAttrs (name: details: (browserAction details)) addons.details;
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
                  addonActions.bitwarden
                  addonActions.simple-tab-groups
                ];
                PersonalToolbar = [ "personal-bookmarks" ];
                TabsToolbar = [
                  "firefox-view-button"
                  "tabbrowser-tabs"
                  "new-tab-button"
                  "alltabs-button"
                  addonActions.temporary-containers
                ];
                toolbar-menubar = [ "menubar-items" ];
                unified-extensions-area = [
                  # Ad-blocking / privacy
                  addonActions.ublock-origin
                  addonActions.privacy-badger
                  addonActions.clearurls
                  addonActions.localcdn
                  # Styling
                  addonActions.darkreader
                  addonActions.stylus
                  # Miscellaneous
                  addonActions.terms-of-service-didnt-read
                  addonActions.librezam
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
                    actionsList = lib.attrsToList addonActions;
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

          # Simple Tab Groups
          "svg.context-properties.content.enabled" = true;

          # Startup
          "browser.startup.page" = 3; # 0=blank, 1=home, 2=last visited page, 3=resume previous session
          "browser.startup.homepage" = "about:home";

          "browser.newtabpage.enabled" = true;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";

          # Disable first-run information
          "browser.bookmarks.addedImportButton" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;

          # ----- Behavior -----

          "general.autoScroll" = true;
          "general.useragent.locale" = "en-US";

          "browser.aboutConfig.showWarning" = false;
          "browser.download.useDownloadDir" = false;

          # Allow DRM content
          "browser.eme.ui.enabled" = true;
          "media.eme.enabled" = true;

          # Disable autofill
          "dom.forms.autocomplete.formautofill" = false;
          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;
          "signon.rememberSignons" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          # Disable Pocket
          "extensions.pocket.enabled" = false;

          # Disable notifications
          "dom.webnotifications.enabled" = false;

          # ----- Security -----

          # Force 3s delay on security dialogs
          "security.dialog_enable_delay" = 3000;

          # Enable HTTPS-only mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;

          # Force DNS-over-HTTPS
          "network.trr.mode" = 3; # 0=default, 2=increased, 3=max, 5=off
          "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

          # Require OCSP validation
          "security.OCSP.enabled" = 1; # 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
          "security.OCSP.require" = true;

          # ----- Privacy -----

          "browser.contentblocking.category" = "strict"; # "standard", "strict"
          "privacy.trackingprotection.enabled" = true;

          # Disable recommendations in about:addons
          "browser.discovery.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # Disable various telemetry
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
        };
      };
    };
  };
}
