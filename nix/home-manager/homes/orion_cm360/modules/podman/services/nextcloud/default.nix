{
  config,
  inputs,
  ...
}:
let
  dbDataDir = "${config.home.homeDirectory}/podman/nextcloud/db-data";
  serverDataDir = "${config.home.homeDirectory}/podman/nextcloud/server-data";
in
{
  services.podman.networks.nextcloud = {
    driver = "bridge";
    description = "Podman Nextcloud network";
    subnet = inputs.secrets.podman.networks.nextcloud.subnet;
  };

  services.podman.containers.nextcloud-db = {
    image = "docker.io/mariadb:10.6";
    autoStart = true;
    autoUpdate = "registry";

    entrypoint = builtins.toJSON [
      "docker-entrypoint.sh"
      "--transaction-isolation=READ-COMMITTED"
      "--log-bin=binlog"
      "--binlog-format=ROW"
    ];

    userNS = "host";

    network = [
      "nextcloud:ip=${inputs.secrets.podman.networks.nextcloud.containers.nextcloud-db}"
    ];

    volumes = [
      "${dbDataDir}:/var/lib/mysql:rw"
      "${config.sops.secrets."podman/nextcloud/mysql_root_password".path}:/secrets/mysql_root_password:ro"
      "${config.sops.secrets."podman/nextcloud/mysql_password".path}:/secrets/mysql_password:ro"
    ];

    environment = {
      MYSQL_ROOT_PASSWORD_FILE = "/secrets/mysql_root_password";
      MYSQL_PASSWORD_FILE = "/secrets/mysql_password";
      MYSQL_DATABASE = "nextcloud";
      MYSQL_USER = "nextcloud";
    };

    extraConfig = {
      Unit = {
        Wants = [ "network-online.target" ]; # might be ignored
        Requires = [ "podman-nextcloud-network.service" ];
        After = [ "podman-nextcloud-network.service" ];
      };
    };

    extraPodmanArgs = [
      "--group-add=keep-groups"
    ];
  };

  services.podman.containers.nextcloud-server = {
    # https://docs.nextcloud.com/server/31/admin_manual/maintenance/update.html
    image = "docker.io/nextcloud:stable";
    autoStart = true;
    autoUpdate = "registry";

    userNS = "host";

    network = [
      "nextcloud:ip=${inputs.secrets.podman.networks.nextcloud.containers.nextcloud-server}"
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.nextcloud-server}"
      # TODO: ldap
    ];

    volumes = [
      "${serverDataDir}:/var/www/html:rw"
      "${config.sops.secrets."podman/nextcloud/mysql_password".path}:/secrets/mysql_password:ro"
      "${config.sops.secrets."podman/nextcloud/admin_password".path}:/secrets/admin_password:ro"
    ];

    # https://github.com/nextcloud/docker
    environment = {
      # Database
      MYSQL_PASSWORD_FILE = "/secrets/mysql_password";
      MYSQL_DATABASE = "nextcloud";
      MYSQL_USER = "nextcloud";
      MYSQL_HOST = inputs.secrets.podman.networks.nextcloud.containers.nextcloud-db;
      # Admin
      NEXTCLOUD_ADMIN_USER = "admin";
      NEXTCLOUD_ADMIN_PASSWORD_FILE = "/secrets/admin_password";
      # Proxy
      NEXTCLOUD_TRUSTED_DOMAINS = "cloud.${inputs.secrets.domain}";
      APACHE_DISABLE_REWRITE_IP = 1;
      TRUSTED_PROXIES = inputs.secrets.podman.networks.proxy.containers.nginx;
    };

    extraConfig = {
      Unit = {
        Wants = [ "network-online.target" ]; # might be ignored
        Requires = [
          "podman-nextcloud-network.service"
          "podman-nextcloud-db.service"
          "podman-proxy-network.service"
          # "podman-ldap-network.service"
        ];
        After = [
          "podman-nextcloud-network.service"
          "podman-nextcloud-db.service"
          "podman-proxy-network.service"
          # "podman-ldap-network.service"
        ];
      };
    };

    extraPodmanArgs = [
      "--group-add=keep-groups"
    ];
  };

  systemd.user.tmpfiles.rules = [
    # ''d "${dbDataDir}" 0700 ${config.home.username} users''
    # ''d "${serverDataDir}" 0700 ${config.home.username} users''
  ];
}
