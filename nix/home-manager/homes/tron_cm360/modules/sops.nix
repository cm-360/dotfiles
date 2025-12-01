{ config, inputs, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/tron_cm360/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "ssh/id_ed25519" = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "ssh/id_ed25519.pub" = {
        mode = "0644";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };
}
