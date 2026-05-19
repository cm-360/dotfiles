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

    settings = {
      ConsoleColorScheme = "LightBackground";
    };
  };
}
