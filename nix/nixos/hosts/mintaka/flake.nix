{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      hostname = "mintaka";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix

            { networking.hostName = "${hostname}"; }
          ];
        };
      };
    };
}
