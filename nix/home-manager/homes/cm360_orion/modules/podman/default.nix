{ pkgs, ... }:
{
  imports = [
    ./networks.nix
    ./services/headscale
    ./services/lldap
    ./services/nextcloud
    ./services/nginx
    ./services/synapse
    ./services/vaultwarden
  ];

  services.podman = {
    enable = true;

    autoUpdate = {
      enable = true;
      onCalendar = "Sun *-*-* 00:00";
    };
  };

  # https://github.com/containers/podman/issues/4972
  home.packages = [ pkgs.iptables ];
}
