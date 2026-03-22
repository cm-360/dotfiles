{
  config,
  inputs,
  ...
}:
let
  dataDir = "${config.home.homeDirectory}/podman/vaultwarden/data";
in
{
  services.podman.containers.vaultwarden = {
    image = "docker.io/vaultwarden/server:latest-alpine";
    autoStart = true;
    autoUpdate = "registry";

    userNS = "keep-id";
    user = 1000; # cm360
    group = 100; # users

    network = [
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.vaultwarden}"
    ];

    volumes = [ "${dataDir}:/data:rw" ];

    # https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
    environment = {
      DATA_FOLDER = "/data";
      DATABASE_URL = "/data/db.sqlite3";

      DOMAIN = "https://vault.${inputs.secrets.domain}";
      SIGNUPS_ALLOWED = "false";
      INVITATION_ORG_NAME = inputs.secrets.domain;

      ROCKET_PORT = 8000;
    };
    environmentFile = [
      config.sops.secrets."podman/vaultwarden/admin_token_env".path
      config.sops.secrets."podman/vaultwarden/smtp_env".path
    ];

    extraConfig = {
      Unit = {
        Requires = [ "podman-proxy-network.service" ];
        After = [ "podman-proxy-network.service" ];
      };
    };

    extraPodmanArgs = [
      "--group-add=keep-groups"
    ];
  };

  # https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
  systemd.user.tmpfiles.rules = [
    ''d "${dataDir}" 0700 ${config.home.username} users''
  ];
}
