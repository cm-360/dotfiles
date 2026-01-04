{ inputs, ... }:
{
  imports = [
    inputs.vscode-server.homeModules.default
  ];

  # https://github.com/nix-community/nixos-vscode-server
  services.vscode-server = {
    enable = true;
    installPath = "$HOME/.vscodium-server";
  };
}
