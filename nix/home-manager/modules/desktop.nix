{ pkgs, lib, ... }:

{
  home.activation = {
    updateDesktopIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.desktop-file-utils}/bin/update-desktop-database -v ~/.local/share/applications
    '';
  };
}
