{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/tron_host/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "luks/cryptdata.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/tron_host/cryptdata.key";
        mode = "0600";
        path = "/etc/cryptdata.key";
      };
      "luks/cryptexthdd.key" = {
        format = "binary";
        sopsFile = "${inputs.secrets}/sops/tron_host/cryptexthdd.key";
        mode = "0600";
        path = "/etc/cryptexthdd.key";
      };

      "hashed_passwords/root".neededForUsers = true;
      "hashed_passwords/cm360".neededForUsers = true;
    };
  };
}
