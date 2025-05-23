{
  programs.plasma = {
    # ~/.config/plasma-org.kde.plasma.desktop-appletsrc
    panels = [
      {
        location = "bottom";
        floating = true;
        hiding = "dodgewindows";
        screen = 0;

        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake";
                alphaSort = true;
              };
            };
          }
          {
            name = "org.kde.plasma.systemmonitor.cpu";
            config = {
              Appearance = {
                chartFace = "org.kde.ksysguard.colorgrid";
                title = "CPU Usage";
                updateRateLimit = 2000;
              };
            };
          }
          {
            name = "org.kde.plasma.systemmonitor.memory";
            config = {
              Appearance = {
                chartFace = "org.kde.ksysguard.colorgrid";
                title = "Memory Usage";
                updateRateLimit = 2000;
              };
            };
          }
          "org.kde.plasma.panelspacer"
          {
            iconTasks = {
              # Pinned taskbar apps
              # System: /run/current-system/sw/share/applications
              # User: ~/.nix-profile/share/applications
              launchers = [
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:vesktop.desktop"
                "applications:codium.desktop"
                "applications:spotify.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                customDateFormat = "ddd, MMM d, yyyy";
                dateFormat = "custom";
              };
            };
          }
        ];
      }
    ];
  };
}
