{ pkgs, ... }:

{
  systemd.user.services.bluetoothPowerOnBoot = {
    Unit.Description = "Automatically power on the default bluetooth controller ";
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${pkgs.writeShellScript "power-on-bluetooth" ''
      #!/usr/bin/env bash
      /run/current-system/sw/bin/bluetoothctl power on
    ''}";
  };
}
