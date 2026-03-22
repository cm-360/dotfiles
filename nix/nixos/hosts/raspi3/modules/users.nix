{ config, ... }:
{
  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.sops.secrets."hashed_passwords/root".path;
      };
      cm360 = {
        uid = 1000;
        hashedPasswordFile = config.sops.secrets."hashed_passwords/cm360".path;
      };
    };
  };
}
