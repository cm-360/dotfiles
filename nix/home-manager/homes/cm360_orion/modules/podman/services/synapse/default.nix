{
  config,
  pkgs,
  inputs,
  ...
}:
let
  podName = "synapse";

  dbDataDir = "${config.home.homeDirectory}/podman/synapse/db-data";
  serverDataDir = "${config.home.homeDirectory}/podman/synapse/server-data";

  homeserverYaml = pkgs.replaceVars ./homeserver.yaml {
    domain = inputs.secrets.domain;
    db_host = inputs.secrets.podman.networks.synapse.containers.synapse-db;
    base_dn = inputs.secrets.lldap.base_dn;
  };
in
{
  services.podman.networks.synapse = {
    driver = "bridge";
    description = "Podman Synapse network";
    subnet = inputs.secrets.podman.networks.synapse.subnet;
  };

  # https://discourse.nixos.org/t/rootless-podman-setup-with-home-manager/57905
  systemd.user.services."pod-${podName}" = {
    Unit = {
      Description = "Podman Synapse pod";
      Wants = [ "network-online.target" ]; # might be ignored
      After = [ "network-online.target" ]; # might be ignored
    };
    Install = {
      WantedBy = [
        "podman-synapse-db.service"
        "podman-synapse-server.service"
      ];
    };
    Service = {
      Type = "forking";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/sleep 3s" # needed for pod to start automatically
        ''
          -${pkgs.podman}/bin/podman pod create --replace \
            --userns keep-id \
            --label PODMAN_SYSTEMD_UNIT="pod-${podName}.service" \
            ${podName}
        ''
      ];
      ExecStart = "${pkgs.podman}/bin/podman pod start ${podName}";
      ExecStop = "${pkgs.podman}/bin/podman pod stop ${podName}";
      RestartSec = "1s";
    };
  };

  services.podman.containers.synapse-db = {
    # https://thomasbandt.com/postgres-docker-major-version-upgrade
    image = "docker.io/postgres:12-alpine";
    autoStart = true;
    autoUpdate = "registry";

    user = 1000; # cm360
    group = 100; # users

    network = [
      "synapse:ip=${inputs.secrets.podman.networks.synapse.containers.synapse-db}"
    ];

    volumes = [
      "${dbDataDir}:/var/lib/postgresql/data:rw"
      "${config.sops.secrets."podman/synapse/postgres_password".path}:/secrets/postgres_password:ro"
    ];

    environment = {
      POSTGRES_USER = "synapse";
      POSTGRES_PASSWORD_FILE = "/secrets/postgres_password";
      # https://element-hq.github.io/synapse/latest/postgres.html#set-up-database
      POSTGRES_INITDB_ARGS = builtins.concatStringsSep " " [
        "--encoding=UTF-8"
        "--lc-collate=C"
        "--lc-ctype=C"
      ];
    };

    extraConfig = {
      Unit = {
        Wants = [ "network-online.target" ]; # might be ignored
        Requires = [
          "pod-${podName}.service"
          "podman-synapse-network.service"
        ];
        After = [
          "pod-${podName}.service"
          "podman-synapse-network.service"
        ];
      };
    };

    extraPodmanArgs = [
      "--pod=synapse"
      "--group-add=keep-groups"
    ];
  };

  services.podman.containers.synapse-server = {
    image = "docker.io/matrixdotorg/synapse:v1.121.1";
    autoStart = true;
    autoUpdate = "registry";

    user = 1000; # cm360
    group = 100; # users

    network = [
      "synapse:ip=${inputs.secrets.podman.networks.synapse.containers.synapse-server}"
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.synapse-server}"
    ];

    volumes = [
      "${serverDataDir}:/data:rw"
      "${homeserverYaml}:/config/homeserver.yaml:ro"
      "${./log_config.yaml}:/config/log_config.yaml:ro"

      "${config.sops.secrets."podman/synapse/pgpass".path}:/secrets/pgpass:ro"
      "${
        config.sops.secrets."podman/synapse/registration_shared_secret".path
      }:/secrets/registration_shared_secret:ro"
      "${config.sops.secrets."podman/synapse/macaroon_secret_key".path}:/secrets/macaroon_secret_key:ro"
      "${config.sops.secrets."podman/synapse/form_secret".path}:/secrets/form_secret:ro"
      "${config.sops.secrets."podman/synapse/signing_key".path}:/secrets/signing_key:ro"
      # TODO: separate user
      "${config.sops.secrets."podman/lldap/ldap_user_pass".path}:/secrets/ldap_bind_password:ro"
    ];

    environment = {
      SYNAPSE_CONFIG_PATH = "/config/homeserver.yaml";
      # https://www.postgresql.org/docs/current/libpq-pgpass.html
      PGPASSFILE = "/secrets/pgpass";
    };

    extraConfig = {
      Unit = {
        Wants = [ "network-online.target" ]; # might be ignored
        Requires = [
          "pod-${podName}.service"
          "podman-synapse-network.service"
          "podman-synapse-db.service"
          "podman-proxy-network.service"
        ];
        After = [
          "pod-${podName}.service"
          "podman-synapse-network.service"
          "podman-synapse-db.service"
          "podman-proxy-network.service"
        ];
      };
    };

    extraPodmanArgs = [
      "--pod=synapse"
      "--group-add=keep-groups"
    ];
  };

  systemd.user.tmpfiles.rules = [
    ''d "${dbDataDir}" 0700 ${config.home.username} users''
    ''d "${serverDataDir}" 0700 ${config.home.username} users''
  ];
}
