{
  config,
  pkgs,
  ...
}:
{
  systemd.user.services.minecraft-hardcore =
    let
      dataDir = "${config.home.homeDirectory}/minecraft/hardcore";
      serverJar = "fabric-server-mc.1.21.3-loader.0.16.9-launcher.1.0.1.jar";
    in
    {
      Unit = {
        Description = "Minecraft hardcore server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        WorkingDirectory = dataDir;
        ExecStart = ''${pkgs.jdk21_headless}/bin/java -Xmx4G -jar "${serverJar}" nogui'';
      };
    };
}
