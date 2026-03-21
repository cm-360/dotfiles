{ config, inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/users/cm360_nas/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "ssh/authorized_keys" = {
        path = "${config.home.homeDirectory}/.ssh/authorized_keys";
      };
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
