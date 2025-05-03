{ pkgs, ... }:
let
  # Define a custom background package
  # https://discourse.nixos.org/t/sddm-background-on-default-theme/46263/3
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
    dontUnpack = true;
    installPhase = ''
      cp $src $out
    '';
  };
in
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "breeze";
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    kate
    ksshaskpass
    partitionmanager
    qtwebengine

    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        # KDE Connect
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        # KDE Connect
        from = 1714;
        to = 1764;
      }
    ];
  };
}
