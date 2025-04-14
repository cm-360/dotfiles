{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      hostname = "tron";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.distro-grub-themes.nixosModules.${system}.default

            ./configuration.nix

            { networking.hostName = "${hostname}"; }
          ];
        };
      };
    };
}
