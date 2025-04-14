{
  programs.plasma = {
    kwin = {
      # Available buttons:
      # - more-window-actions
      # - application-menu
      # - on-all-desktops
      # - minimize
      # - maximize
      # - close
      # - help
      # - shade
      # - keep-below-windows
      # - keep-above-windows
      titlebarButtons = {
        left = [
          "more-window-actions"
          "keep-above-windows"
        ];
        right = [
          "help"
          "minimize"
          "maximize"
          "close"
        ];
      };
    };
  };
}
