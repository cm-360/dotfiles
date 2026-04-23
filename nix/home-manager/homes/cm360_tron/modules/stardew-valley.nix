{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.smapi-nix.homeModules.default
  ];

  home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.patch-galaxy-api
  ];

  programs.smapi = {
    enable = true;

    gameDir = "/data/cm360/Games/PC/Libraries/Steam-Linux/steamapps/common/Stardew Valley";

    settings = {
      ConsoleColorScheme = "LightBackground";
    };
  };
}
