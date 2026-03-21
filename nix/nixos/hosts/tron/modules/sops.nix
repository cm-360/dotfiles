{
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
    defaultSopsFile = "${inputs.secrets}/sops/hosts/tron/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "hashed_passwords/root".neededForUsers = true;
      "hashed_passwords/cm360".neededForUsers = true;

      "luks/cryptdata.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/hosts/tron/cryptdata.key";
        mode = "0600";
        path = "/etc/cryptdata.key";
      };
      "luks/cryptexthdd.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/hosts/tron/cryptexthdd.key";
        mode = "0600";
        path = "/etc/cryptexthdd.key";
      };

    };
  };
}
