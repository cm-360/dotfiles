{
  imports = [ ./vencord ];

  programs.vesktop = {
    enable = true;
    settings = import ./settings.nix;
  };

  xdg.configFile."vesktop/settings/quickCss.css".source = ./vencord/quickCss.css;
}
