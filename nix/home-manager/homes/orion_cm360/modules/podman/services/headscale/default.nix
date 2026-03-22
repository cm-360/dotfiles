{
  config,
  pkgs,
  inputs,
  ...
}:
let
  dataDir = "${config.home.homeDirectory}/podman/headscale/data";

  configYaml = pkgs.replaceVars ./config.yaml {
    domain = inputs.secrets.domain;
  };
in
{
  services.podman.containers.headscale = {
    image = "docker.io/headscale/headscale:unstable";
    autoStart = true;
    autoUpdate = "registry";

    exec = "serve";
    userNS = "host";

    network = [
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.headscale}"
    ];

    volumes = [
      "${configYaml}:/etc/headscale/config.yaml:ro"
      "${dataDir}/lib:/var/lib/headscale:rw"
      # "${dataDir}/run:/var/run/headscale:rw"
      "${config.sops.secrets."podman/headscale/noise_private_key".path}:/secrets/noise_private.key:ro"
      # "${config.sops.secrets."podman/headscale/derp_server_private_key".path}:/secrets/derp_server_private.key:ro"
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

  systemd.user.tmpfiles.rules = [
    ''d "${dataDir}/lib" 0700 ${config.home.username} users''
    ''d "${dataDir}/run" 0700 ${config.home.username} users''
  ];
}
