{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/hosts/orion/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "hashed_passwords/root".neededForUsers = true;
      "hashed_passwords/cm360".neededForUsers = true;

      "nix/signing-keys/orion-0-private".mode = "0600";
      "nix/signing-keys/orion-0-public".mode = "0644";
    };
  };
}
