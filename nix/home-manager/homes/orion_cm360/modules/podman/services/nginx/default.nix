{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  dataDir = "${config.home.homeDirectory}/podman/nginx";

  nginxConf = pkgs.replaceVars ./nginx.conf {
    domain = inputs.secrets.domain;
  };

  configVolumes = import ./conf.d {
    inherit
      lib
      pkgs
      inputs
      ;
  };
in
{
  services.podman.containers.nginx = {
    image = "docker.io/nginx:alpine";
    autoStart = true;
    autoUpdate = "registry";

    userNS = "host";

    # TODO: remote_addr set incorrectly with rootless Podman
    # https://github.com/containers/podman/issues/17765
    # https://github.com/containers/podman/issues/8193
    # network = [
    #   "slirp4netns:port_handler=slirp4netns"
    #   "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.nginx}"
    # ];

    network = [
      "proxy:ip=${inputs.secrets.podman.networks.proxy.containers.nginx}"
    ];

    ports = [
      "0.0.0.0:8080:80"
      "0.0.0.0:8443:443"
    ];

    volumes = [
      "${nginxConf}:/etc/nginx/nginx.conf:ro"
      "${dataDir}/html:/usr/share/nginx/html:ro"
      "${dataDir}/logs:/var/log/nginx:rw"
      "${dataDir}/certbot/conf:/etc/nginx/ssl/:ro"
      "${config.sops.secrets."podman/nginx/ollama_htpasswd".path}:/etc/nginx/auth/ollama.htpasswd:ro"
    ]
    ++ configVolumes;

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
    ''d "${dataDir}/html" 0755 ${config.home.username} users''
    ''d "${dataDir}/logs" 0700 ${config.home.username} users''
  ];
}
