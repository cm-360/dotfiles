{ pkgs, ... }:
{
  programs.firefox.policies = {
    # https://mozilla.github.io/policy-templates/#securitydevices
    SecurityDevices.Add = {
      "OpenSC PKCS #11 Module" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };
}
