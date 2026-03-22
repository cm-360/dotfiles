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

  home.packages = with pkgs; [
    iptables
  ];
}
