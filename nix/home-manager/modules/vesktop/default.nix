{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./vencord ];

  programs.vesktop = {
    enable = true;
    settings = import ./settings.nix;
  };

  xdg.configFile."vesktop/settings/quickCss.css".source = (
    pkgs.concatText "quickCss.css" [
      ./vencord/quickCss.css
      (pkgs.writeText "extraCss.css" inputs.secrets.vesktop.extraCss)
    ]
  );
}
