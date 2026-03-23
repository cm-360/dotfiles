{
  config,
  inputs,
  ...
}:
let
  dataDir = "${config.home.homeDirectory}/podman/lldap/data";
in
{
  # https://github.com/lldap/lldap
  services.podman.containers.lldap = {
    image = "docker.io/lldap/lldap:latest-alpine-rootless";
    autoStart = true;
    autoUpdate = "registry";

    userNS = "keep-id";
    user = 1000; # cm360
    group = 100; # users

    network = [
      "ldap:ip=${inputs.secrets.podman.networks.ldap.containers.lldap}"
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.lldap}"
    ];

    ports = [
      "192.168.122.1:3890:3890" # expose LDAP to libvirt guests
    ];

    volumes = [
      "${dataDir}:/data:rw"
      "${config.sops.secrets."podman/lldap/key_seed".path}:/secrets/key_seed:ro"
      "${config.sops.secrets."podman/lldap/jwt_secret".path}:/secrets/jwt_secret:ro"
      "${config.sops.secrets."podman/lldap/ldap_user_pass".path}:/secrets/ldap_user_pass:ro"
    ];

    # https://github.com/lldap/lldap/blob/main/docs/install.md
    environment = {
      # LDAP
      LLDAP_DATABASE_URL = "sqlite:///data/users.db?mode=rwc";
      LLDAP_HTTP_URL = "https://ldap.${inputs.secrets.domain}";
      LLDAP_KEY_SEED_FILE = "/secrets/key_seed";
      LLDAP_JWT_SECRET_FILE = "/secrets/jwt_secret";
      LLDAP_LDAP_BASE_DN = inputs.secrets.lldap.base_dn;
      LLDAP_LDAP_USER_PASS_FILE = "/secrets/ldap_user_pass";
      # SSL
      # LLDAP_LDAPS_OPTIONS__ENABLED = "true";
      # LLDAP_LDAPS_OPTIONS__CERT_FILE = "/ssl/cert.pem";
      # LLDAP_LDAPS_OPTIONS__KEY_FILE = "/ssl/key.pem";
    };
    environmentFile = [
      config.sops.secrets."podman/lldap/smtp_env".path
    ];

    extraConfig = {
      Unit = {
        Requires = [
          "podman-ldap-network.service"
          "podman-proxy-network.service"
        ];
        After = [
          "podman-ldap-network.service"
          "podman-proxy-network.service"
        ];
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
