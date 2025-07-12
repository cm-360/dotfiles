{ inputs, lib, ... }:
let
  caCertFiles = import "${inputs.ca-certs}/certs.nix" {
    inherit lib;
  };
in
{
  security.pki.certificateFiles = caCertFiles;
}
