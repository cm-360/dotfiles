{
  lib,
  pkgs,
  inputs,
}:
let
  configFiles = {
    # Podman
    headscale = pkgs.replaceVars ./headscale.conf {
      domain = "headscale.${inputs.secrets.domain}";
      upstream = "${inputs.secrets.podman.networks.proxy.containers.headscale}:8080";
    };
    lldap = pkgs.replaceVars ./generic-proxy-pass.conf {
      domain = "ldap.${inputs.secrets.domain}";
      upstream = "${inputs.secrets.podman.networks.proxy.containers.lldap}:17170";
    };
    nextcloud = pkgs.replaceVars ./nextcloud.conf {
      domain = "cloud.${inputs.secrets.domain}";
      upstream = inputs.secrets.podman.networks.proxy.containers.nextcloud-server;
    };
    synapse = pkgs.replaceVars ./synapse.conf {
      domain = "matrix.${inputs.secrets.domain}";
      upstream = "${inputs.secrets.podman.networks.proxy.containers.synapse-server}:8008";
    };
    vaultwarden = pkgs.replaceVars ./generic-proxy-pass.conf {
      domain = "vault.${inputs.secrets.domain}";
      upstream = "${inputs.secrets.podman.networks.proxy.containers.vaultwarden}:8000";
    };

    # Docker
    qbittorrent = pkgs.replaceVars ./generic-proxy-pass.conf {
      domain = "qbittorrent.${inputs.secrets.domain}";
      upstream = "host.containers.internal:8888";
    };

    # Libvirt
    jellyfin = pkgs.replaceVars ./jellyfin.conf {
      domain = "jellyfin.${inputs.secrets.domain}";
      upstream = "192.168.122.8:8096";
    };
    ollama = pkgs.replaceVars ./ollama.conf {
      domain = "ollama.${inputs.secrets.domain}";
      upstream = "192.168.122.8:11434";
    };

    www = pkgs.replaceVars ./www.conf {
      domain = inputs.secrets.domain;
    };
  };
in
lib.mapAttrsToList (name: file: "${file}:/etc/nginx/conf.d/${name}.conf:ro") configFiles
