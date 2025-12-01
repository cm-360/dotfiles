{
  description = "NixOS and Home Manager configurations";

  inputs = {
    # Nixpkgs
    nixos-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home Manager
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixos-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Miscellaneous
    craftland = {
      url = "github:cm-360/craftland-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    distro-grub-themes = {
      url = "github:AdisonCavani/distro-grub-themes";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    eden = {
      url = "github:grantimatter/eden-flake";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    mpris-discord-rpc = {
      url = "github:cm-360/mpris-discord-rpc?ref=feature/nix-package";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };
    rycee-firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Personal
    ca-certs = {
      url = "git+ssh://git@github.com/cm-360/ca-certs";
      flake = false;
    };
    secrets = {
      url = "git+file:///home/cm360/.dotfiles-secrets";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixos-stable,
      nixos-unstable,
      home-manager-stable,
      home-manager-unstable,
      ...
    }@inputs:
    let
      defaultSystem = "x86_64-linux";
      defaultUsername = "cm360";

      specialArgs =
        {
          system ? defaultSystem,
        }:
        {
          inherit inputs;
          inherit (inputs.rycee-firefox-addons.lib.${system}) buildFirefoxXpiAddon;
        };

      importPkgs =
        {
          pkgs,
          system ? defaultSystem,
        }:
        import pkgs {
          inherit system;
          overlays = [
            (import ./nix/packages)
            inputs.craftland.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.rycee-firefox-addons.overlays.default
            (final: prev: {
              spicetifyPackages = inputs.spicetify-nix.legacyPackages.${system};
            })
          ];
        };

      homeConfig =
        {
          pkgs,
          home-manager,
          system ? defaultSystem,
          hostname,
          username ? defaultUsername,
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = importPkgs { inherit pkgs system; };

          modules = [
            ./nix/home-manager/homes/${hostname}_${username}/home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ]
          ++ extraModules;

          extraSpecialArgs = (specialArgs { inherit system; }) // extraSpecialArgs;
        };

      nixosConfig =
        {
          pkgs,
          system ? defaultSystem,
          hostname,
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        pkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./nix/nixos/hosts/${hostname}/configuration.nix
            {
              networking.hostName = "${hostname}";
            }
          ]
          ++ extraModules;

          specialArgs = (specialArgs { inherit system; }) // extraSpecialArgs;
        };
    in
    {
      homeConfigurations = {
        "${defaultUsername}@air" = homeConfig {
          pkgs = nixos-unstable;
          home-manager = home-manager-unstable;
          hostname = "air";
          extraModules = [
            inputs.mpris-discord-rpc.homeManagerModules.default
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];
        };
        "${defaultUsername}@mintaka" = homeConfig {
          pkgs = nixos-unstable;
          home-manager = home-manager-unstable;
          hostname = "mintaka";
        };
        "${defaultUsername}@orion" = homeConfig {
          pkgs = nixos-unstable;
          home-manager = home-manager-unstable;
          hostname = "orion";
          extraModules = [
            inputs.vscode-server.homeModules.default
          ];
        };
        "${defaultUsername}@tron" = homeConfig {
          pkgs = nixos-unstable;
          home-manager = home-manager-unstable;
          hostname = "tron";
          extraModules = [
            inputs.eden.homeModules.default
            inputs.mpris-discord-rpc.homeManagerModules.default
            inputs.nix-index-database.homeModules.nix-index
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.sops-nix.homeManagerModules.sops
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];
        };
      };

      nixosConfigurations = {
        "air" = nixosConfig {
          pkgs = nixos-unstable;
          hostname = "air";
          extraModules = [
            inputs.distro-grub-themes.nixosModules.${defaultSystem}.default
          ];
        };
        "mintaka" = nixosConfig {
          pkgs = nixos-stable;
          hostname = "mintaka";
        };
        "orion" = nixosConfig {
          pkgs = nixos-stable;
          hostname = "orion";
        };
        "raspi" = nixosConfig {
          pkgs = nixos-unstable;
          system = "aarch64-linux";
          hostname = "raspi";
          extraModules = [
            inputs.nixos-hardware.nixosModules.raspberry-pi-3
          ];
        };
        "tron" = nixosConfig {
          pkgs = nixos-unstable;
          hostname = "tron";
          extraModules = [
            inputs.distro-grub-themes.nixosModules.${defaultSystem}.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
