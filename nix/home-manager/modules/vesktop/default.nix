{
  programs.vesktop = {
    enable = true;
    settings = import ./settings.nix;
    vencord.settings = import ./vencord/settings.nix;
  };

  xdg.configFile."vesktop/settings/quickCss.css".source = ./vencord/quickCss.css;
}
