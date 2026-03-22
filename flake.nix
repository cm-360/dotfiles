{
  description = "NixOS and Home Manager configurations";

  inputs = {
    # Nixpkgs
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi = {
      # https://github.com/nvmd/nixos-raspberrypi/pull/131
      url = "github:nvmd/nixos-raspberrypi/remove-options-compat";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

    # Home Manager
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
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
      url = "git+ssh://cm360@orion/home/cm360/secrets.git";
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
          nixosSystem ? pkgs.lib.nixosSystem,
          system ? defaultSystem,
          hostname,
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        nixosSystem {
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
        };
        "${defaultUsername}@tron" = homeConfig {
          pkgs = nixos-unstable;
          home-manager = home-manager-unstable;
          hostname = "tron";
        };
      };

      nixosConfigurations = {
        "air" = nixosConfig {
          pkgs = nixos-unstable;
          hostname = "air";
        };
        "mintaka" = nixosConfig {
          pkgs = nixos-stable;
          hostname = "mintaka";
        };
        "orion" = nixosConfig {
          pkgs = nixos-stable;
          hostname = "orion";
        };
        "raspi3" = nixosConfig {
          pkgs = nixos-unstable;
          system = "aarch64-linux";
          hostname = "raspi3";
        };
        "raspi5" = nixosConfig {
          pkgs = nixos-unstable;
          nixosSystem = inputs.nixos-raspberrypi.lib.nixosSystem;
          system = "aarch64-linux";
          hostname = "raspi5";
          extraSpecialArgs = {
            inherit (inputs) nixos-raspberrypi;
          };
        };
        "tron" = nixosConfig {
          pkgs = nixos-unstable;
          hostname = "tron";
        };
        "nas" = nixosConfig {
          pkgs = nixos-stable;
          hostname = "nas";
        };
      };
    };
}
