{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/hosts/${config.networking.hostName}/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "hashed_passwords/root".neededForUsers = true;
      "hashed_passwords/cm360".neededForUsers = true;

      "luks/cryptdata.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/hosts/${config.networking.hostName}/cryptdata.key";
        mode = "0600";
        path = "/etc/cryptdata.key";
      };
      "luks/cryptexthdd.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/hosts/${config.networking.hostName}/cryptexthdd.key";
        mode = "0600";
        path = "/etc/cryptexthdd.key";
      };

      "nix/signing-keys/${config.networking.hostName}-0-private".mode = "0600";
      "nix/signing-keys/${config.networking.hostName}-0-public".mode = "0644";
    };
  };
}
