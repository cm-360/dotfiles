{ pkgs, ... }:
let
  param = name: value: {
    inherit name;
    inherit value;
  };

  daily = 24 * 60 * 60 * 1000;
in
{
  # ----- General ------

  # TODO: Test various Searx instances: https://searx.space/

  # https://addons.mozilla.org/en-US/firefox/opensearch.xml
  firefox-addons = {
    name = "Firefox Add-ons";
    urls = [ { template = "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}"; } ];
    icon = "https://addons.mozilla.org/favicon.ico";
    metaData.hideOneOffButton = true;
    updateInterval = daily;
    definedAliases = [ "@addons" ];
  };

  # https://www.openstreetmap.org/assets/osm-42b7b3fbcee2193e455a773db6cd3d34a2f48ca94547fed54901dd9d8307b02b.xml
  openstreetmap = {
    name = "OpenStreetMap";
    description = "Search for a place in OpenStreetMap";
    urls = [ { template = "https://www.openstreetmap.org/search?query={searchTerms}"; } ];
    icon = "https://www.openstreetmap.org/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@osm" ];
  };

  # https://www.startpage.com/sp/cdn/opensearch/en/opensearch.xml
  startpage = {
    name = "Startpage";
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
    updateInterval = daily;
    definedAliases = [ "@startpage" ];
  };

  # https://www.youtube.com/opensearch?locale=en_US
  youtube = {
    name = "YouTube";
    description = "Search for videos on YouTube";
    urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
    icon = "https://www.youtube.com/favicon.ico";
    updateInterval = daily;
    definedAliases = [ "@youtube" ];
  };

  # ----- Games -----

  # https://minecraft.wiki/opensearch_desc.php
  minecraft-wiki = {
    name = "Minecraft Wiki";
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
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@minecraft" ];
  };

  # https://modrinth.com/opensearch.xml
  modrinth-mods = {
    name = "Modrinth Mods";
    description = "Search for mods on Modrinth, the open source modding platform.";
    urls = [ { template = "https://modrinth.com/mods?q={searchTerms}"; } ];
    icon = "https://modrinth.com/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@modrinth" ];
  };

  # https://terraria.wiki.gg/rest.php/v1/search
  terraria-wiki = {
    name = "Terraria Wiki";
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
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@terraria" ];
  };

  # https://calamitymod.wiki.gg/rest.php/v1/search
  calamity-mod-wiki = {
    name = "Calamity Mod Wiki";
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
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@calamity" ];
  };

  # ----- Development -----

  # https://github.com/opensearch.xml
  github = {
    name = "GitHub";
    urls = [ { template = "https://github.com/search?q={searchTerms}&ref=opensearch"; } ];
    icon = "https://github.com/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@github" ];
  };

  # https://developer.mozilla.org/opensearch.xml
  mdn-web-docs = {
    name = "MDN Web Docs";
    urls = [ { template = "https://developer.mozilla.org/search?q={searchTerms}"; } ];
    icon = "https://developer.mozilla.org/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@mdn" ];
  };

  # https://docs.python.org/3/_static/opensearch.xml
  python3-docs = {
    name = "Python 3 Docs";
    urls = [ { template = "https://docs.python.org/3/search.html?q={searchTerms}"; } ];
    icon = "https://docs.python.org/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@python" ];
  };

  # https://pypi.org/opensearch.xml
  pypi = {
    name = "PyPI";
    urls = [ { template = "https://pypi.org/search/?q={searchTerms}"; } ];
    icon = "https://pypi.org/favicon.ico";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@pypi" ];
  };

  # https://svelte.dev/opensearch.xml
  svelte = {
    name = "Svelte";
    urls = [ { template = "https://svelte.dev/search?q={searchTerms}"; } ];
    icon = "https://svelte.dev/favicon.png";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@svelte" ];
  };

  # ----- Nix -----

  # https://search.nixos.org/desc-search-packages.xml
  nix-packages = {
    name = "Nix Packages";
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

  # https://search.nixos.org/desc-search-options.xml
  nixos-options = {
    name = "NixOS Options";
    urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    metaData.hideOneOffButton = true;
    definedAliases = [ "@nixopts" ];
  };

  # https://nixos.wiki/opensearch_desc.php
  nixos-wiki = {
    name = "NixOS Wiki";
    urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    metaData.hideOneOffButton = true;
    definedAliases = [ "@nixwiki" ];
  };

  # https://home-manager-options.extranix.com/opensearch.xml
  home-manager-options = {
    name = "Home Manager Options";
    urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
    icon = "https://home-manager-options.extranix.com/images/favicon.png";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@hmopts" ];
  };

  # https://mynixos.com/opensearch.xml
  mynixos = {
    name = "MyNixOS";
    urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
    icon = "https://mynixos.com/favicon-64x64.png";
    updateInterval = daily;
    metaData.hideOneOffButton = true;
    definedAliases = [ "@mynixos" ];
  };
}
