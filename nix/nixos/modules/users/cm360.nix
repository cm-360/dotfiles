{ pkgs, ... }:
{
  users.users.cm360 = {
    isNormalUser = true;
    description = "CM360";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };
}
