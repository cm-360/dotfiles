{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager-stable.nixosModules.home-manager
  ];

  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.sops.secrets."hashed_passwords/root".path;
      };
      cm360 = {
        uid = 1000;
        hashedPasswordFile = config.sops.secrets."hashed_passwords/cm360".path;
        linger = true;
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.cm360 = "${inputs.self}/nix/home-manager/homes/${config.networking.hostName}_cm360/home.nix";
  };
}
