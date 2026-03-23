# cat /proc/bus/input/devices
{
  programs.plasma = {
    input.keyboard.numlockOnStartup = "on"; # "on", "off", "unchanged"

    input.mice = [
      {
        name = "Logitech G502 X Plus";
        vendorId = "046d";
        productId = "c095";

        accelerationProfile = "none";
      }
    ];

    input.touchpads = [
      {
        name = "DELL0A75:00 06CB:7A13 Touchpad";
        vendorId = "06cb";
        productId = "7a13";

        # accelerationProfile = "default";
        naturalScroll = true;
      }
    ];
  };
}
