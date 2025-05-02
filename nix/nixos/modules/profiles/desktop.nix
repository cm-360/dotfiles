{
  imports = [
    ../global
    ../service-audio.nix
  ];

  # Enable hardware acceleration (OpenGL)
  hardware.graphics.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable OpenTabletDriver for drawing tablet support
  hardware.opentabletdriver.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;
}
