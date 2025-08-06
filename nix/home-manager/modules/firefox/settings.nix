# about:config
# ~/.mozilla/firefox/<profile>/prefs.js
# ~/.mozilla/firefox/<profile>/user.js
{
  # Thank-you to:
  # - https://github.com/arkenfox/user.js/blob/master/user.js
  # - https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
  # - https://github.com/Misterio77/nix-config/blob/2097eac0158e1604bd52c918728729850c6fe746/home/gabriel/features/desktop/common/firefox.nix
  # - https://brainfucksec.github.io/firefox-hardening-guide

  # ----- Behavior -----

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

  "general.autoScroll" = true;
  "general.useragent.locale" = "en-US";

  "browser.aboutConfig.showWarning" = false;
  "browser.download.useDownloadDir" = false;
  "browser.urlbar.trimURLs" = false;

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
}
