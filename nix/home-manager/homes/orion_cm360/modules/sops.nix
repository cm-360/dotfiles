{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/users/cm360_orion/secrets.yaml";
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
      "ssh/id_ed25519_sftp" = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519_sftp";
      };
      "ssh/id_ed25519_sftp.pub" = {
        mode = "0644";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519_sftp.pub";
      };

      "podman/headscale/noise_private_key".mode = "0600";
      # "podman/headscale/derp_server_private_key".mode = "0600";

      "podman/lldap/key_seed".mode = "0600";
      "podman/lldap/jwt_secret".mode = "0600";
      "podman/lldap/ldap_user_pass".mode = "0600";
      "podman/lldap/smtp_env".mode = "0600";

      "podman/nextcloud/mysql_root_password".mode = "0600";
      "podman/nextcloud/mysql_password".mode = "0600";
      "podman/nextcloud/admin_user".mode = "0600";
      "podman/nextcloud/admin_password".mode = "0600";

      "podman/nginx/ollama_htpasswd".mode = "0600";

      "podman/synapse/postgres_password".mode = "0600";
      "podman/synapse/pgpass".mode = "0600";
      "podman/synapse/registration_shared_secret".mode = "0600";
      "podman/synapse/macaroon_secret_key".mode = "0600";
      "podman/synapse/form_secret".mode = "0600";
      "podman/synapse/signing_key".mode = "0600";

      "podman/vaultwarden/admin_token_env".mode = "0600";
      "podman/vaultwarden/smtp_env".mode = "0600";
    };
  };
}
