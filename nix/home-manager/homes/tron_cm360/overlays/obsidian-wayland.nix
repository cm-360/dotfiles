(final: prev: {
  # Fixes launching on wayland
  obsidian = prev.obsidian.overrideAttrs (oldAttrs: rec {
    desktopItem = oldAttrs.desktopItem.override (oldDesktop: {
      exec = "${oldDesktop.exec} --disable-gpu";
    });
    installPhase = (
      builtins.replaceStrings [ "${oldAttrs.desktopItem}" ] [ "${desktopItem}" ] oldAttrs.installPhase
    );
  });
})
