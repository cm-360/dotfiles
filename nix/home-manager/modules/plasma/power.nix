{
  programs.plasma = {
    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        whenLaptopLidClosed = "turnOffScreen";
      };
      battery = {
        whenLaptopLidClosed = "turnOffScreen";
      };
    };
  };
}
