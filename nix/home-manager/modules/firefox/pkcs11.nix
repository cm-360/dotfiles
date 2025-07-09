{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.activation = {
    addFirefoxOpenScPkcs11Module = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PROFILE_NAME="default"
      PROFILE_DIR="${config.home.homeDirectory}/.mozilla/firefox/$PROFILE_NAME"

      MODULE_NAME="OpenSC PKCS#11 Module"
      MODULE_LIB="${pkgs.opensc}/lib/opensc-pkcs11.so"

      MODUTIL_BIN="${pkgs.nssTools}/bin/modutil"
      MODUTIL="$MODUTIL_BIN -dbdir $PROFILE_DIR -force"

      if ! $MODUTIL -list | grep -Fq "$MODULE_NAME"; then
        $MODUTIL -add "$MODULE_NAME" -libfile "$MODULE_LIB"
      fi
    '';
  };
}
