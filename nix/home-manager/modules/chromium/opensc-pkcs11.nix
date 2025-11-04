{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation.addChromiumOpenscPkcs11Module = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      dbdir = "${config.home.homeDirectory}/.pki/nssdb";
      moduleName = "OpenSC PKCS #11 Module";
      moduleLib = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    in
    ''
      mkdir -p "${dbdir}"
      modutil="${pkgs.nssTools}/bin/modutil -dbdir ${dbdir}"

      currentLibPath=$(
        $modutil -list '${moduleName}' 2>/dev/null \
        | grep -F "Library file:" \
        | ${pkgs.gawk}/bin/awk -F ': ' '{print $2}' \
        || true
      )

      if [ "$currentLibPath" != "${moduleLib}" ]; then
        $modutil -force -delete '${moduleName}' || true
        $modutil -force -add '${moduleName}' -libfile "${moduleLib}"
      fi
    ''
  );
}
