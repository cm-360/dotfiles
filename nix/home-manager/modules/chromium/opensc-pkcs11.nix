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
      modutilBin = "${pkgs.nssTools}/bin/modutil";
    in
    ''
      mkdir -p "${dbdir}"
      modutil="${modutilBin} -dbdir ${dbdir}"
      if ! $modutil -list | grep -Fq "${moduleName}"; then
        $modutil -force -add "${moduleName}" -libfile "${moduleLib}"
      fi
    ''
  );
}
