{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkMinecraftService =
    {
      name,
      autostart ? true,
      execStart,
      execStartPre ? [ ],
    }:
    {
      "minecraft-${name}" = {
        Unit = {
          Description = "Minecraft ${name} server";
        };
        Install = {
          WantedBy = lib.optionals autostart [ "default.target" ];
        };
        Service = {
          WorkingDirectory = "${config.home.homeDirectory}/minecraft/${name}";
          ExecStartPre = execStartPre;
          ExecStart = execStart;
        };
      };
    };

  applyJson = pkgs.writeShellApplication {
    name = "apply-json";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
    ];

    text = ''
      target="$1"
      src="$2"

      mkdir -p "$(dirname "$target")"

      if [ -f "$target" ]; then
        jq -s '.[0] * .[1]' <(cat "$target") "$src" > "$target.tmp"
        mv "$target.tmp" "$target"
      else
        cp "$src" "$target"
      fi
    '';
  };

  applyToml = pkgs.writeShellApplication {
    name = "apply-toml";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.yq
    ];

    text = ''
      target="$1"
      src="$2"

      mkdir -p "$(dirname "$target")"

      if [ -f "$target" ]; then
        tomlq -t -s '.[0] * .[1]' "$target" "$src" > "$target.tmp"
        mv "$target.tmp" "$target"
      else
        cp "$src" "$target"
      fi
    '';
  };

  inherit (lib.strings) hasSuffix;

  applyForPath =
    path:
    if hasSuffix ".json" path then
      "${applyJson}/bin/apply-json"
    else if hasSuffix ".toml" path then
      "${applyToml}/bin/apply-toml"
    else
      throw "Unsupported config type: ${path}";

  renderConfig =
    path: value:
    if hasSuffix ".json" path then
      pkgs.writeText path (builtins.toJSON value)
    else if hasSuffix ".toml" path then
      (pkgs.formats.toml { }).generate path value
    else
      throw "Unsupported config type: ${path}";

  applyConfigs =
    configs:
    lib.mapAttrsToList (
      path: value: ''${applyForPath path} "${path}" "${renderConfig path value}"''
    ) configs;
in
{
  systemd.user.services = lib.mkMerge [
    (mkMinecraftService {
      name = "hardcore";
      autostart = false;
      execStart =
        let
          serverJar = "fabric-server-mc.1.21.3-loader.0.16.9-launcher.1.0.1.jar";
        in
        ''${pkgs.jdk21_headless}/bin/java -Xmx4G -jar "${serverJar}" nogui'';
    })
    (
      let
        jvmArgs = builtins.concatStringsSep " " [
          "-Xmx8G"
          "-XX:+UseZGC"
          "-XX:+ZGenerational"
        ];

        neoforgeArg = "@libraries/net/neoforged/neoforge/21.1.228/unix_args.txt";

        configs = {
          "config/aether-common.toml" = {
            Gameplay = {
              "Use default Accessories' menu" = true;
            };
            "Data Pack" = {
              "Add Temporary Freezing automatically" = true;
              "Add Ruined Portals automatically" = true;
            };
          };
        };
      in
      mkMinecraftService {
        name = "skys-the-limit";
        execStartPre = (applyConfigs configs);
        execStart = "${pkgs.jdk21_headless}/bin/java ${jvmArgs} ${neoforgeArg} nogui";
      }
    )
  ];
}
