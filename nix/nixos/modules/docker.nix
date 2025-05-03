{ config, ... }:
{
  virtualisation.docker = {
    enable = true;

    storageDriver =
      if config.fileSystems."/" != null then
        (if "btrfs" == config.fileSystems."/".fsType then "btrfs" else null)
      else
        null;
  };
}
