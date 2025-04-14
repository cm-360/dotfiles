{
  imports = [
    ./desktop.nix
  ];

  # Enable libinput for touchpad support (enabled by default in most desktop managers)
  services.libinput.enable = true;

  # Enable Touchegg for touchpad gestures
  services.touchegg.enable = true;
}
