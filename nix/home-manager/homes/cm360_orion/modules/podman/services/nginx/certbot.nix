{
  config,
  pkgs,
  inputs,
  ...
}:
let
  dataDir = "${config.home.homeDirectory}/podman/nginx/certbot";

  renewalScript = pkgs.writeShellScript "certbot-renew.sh" ''
    export NAMECHEAP_USERNAME=$(< ${config.sops.secrets."namecheap/username".path})
    export NAMECHEAP_PASSWORD=$(< ${config.sops.secrets."namecheap/password".path})
    export NAMECHEAP_TOTP_SECRET=$(< ${config.sops.secrets."namecheap/totp_secret".path})

    ${pkgs.namecheap-certbot}/bin/namecheap-certbot certonly \
      --config-dir "${dataDir}/conf" \
      --logs-dir "${dataDir}/logs" \
      --work-dir "${dataDir}/lib" \
      --deploy-hook "systemctl restart --user podman-nginx.service" \
      -d '*.${inputs.secrets.domain},${inputs.secrets.domain}'
  '';
in
{
  home.packages = [ pkgs.namecheap-certbot ];

  systemd.user.timers.certbot-renew = {
    Unit = {
      Description = "Renew SSL certificates for nginx with namecheap-certbot";
      Wants = [ "network-online.target" ];
    };
    Timer = {
      # First Sunday of every month at 1:00 am ET
      OnCalendar = "Sun *-*-1..7 01:00:00 America/New_York";
      Persistent = true;
      Unit = "certbot-renew.service";
    };
  };

  systemd.user.services.certbot-renew = {
    Unit = {
      Description = "Renew SSL certificates for nginx with namecheap-certbot";
    };
    Service = {
      Type = "oneshot";
      ExecStart = renewalScript;
      Restart = "on-failure";
    };
  };

  systemd.user.tmpfiles.rules = [
    ''d "${dataDir}/conf" 0755 ${config.home.username} users''
    ''d "${dataDir}/logs" 0700 ${config.home.username} users''
    ''d "${dataDir}/lib" 0755 ${config.home.username} users''
  ];
}
