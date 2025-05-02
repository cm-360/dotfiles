{
  description = "NixOS Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    mpris-discord-rpc = {
      # url = "git+file:///home/cm360/Projects/mpris-discord-rpc";
      url = "github:cm-360/mpris-discord-rpc?ref=feature/nix-package";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      plasma-manager,
      mpris-discord-rpc,
      nix-vscode-extensions,
      ...
    }:
    let
      username = "cm360";
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              nix-vscode-extensions.overlays.default
            ];
          };

          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            mpris-discord-rpc.homeManagerModules.default

            ./home.nix

            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ];
        };
      };
    };
}
