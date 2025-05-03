(final: prev: {
  # Gives Vesktop the Discord icon (still an ally <3)
  # From https://www.reddit.com/r/NixOS/comments/1dagbfv/comment/l7k5lpm/
  vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
    desktopItems = [
      ((builtins.elemAt oldAttrs.desktopItems 0).override { icon = "discord"; })
    ];
  });
})
