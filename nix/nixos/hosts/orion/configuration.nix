{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/profiles/server.nix
    ../../modules/users/cm360.nix

    ../../modules/docker.nix
    ../../modules/libvirt.nix

    ./modules/hardware/boot.nix
    ./modules/hardware/filesystems.nix
    ./modules/sops.nix
    ./modules/users.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    secret-key-files = [
      "${config.sops.secrets."nix/signing-keys/orion-0-private".path}"
    ];
    inherit (inputs.secrets.nix) trusted-public-keys;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  services.tailscale.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      # HTTP(S)
      80
      443
      8080
      8443
      # Minecraft Java
      25565
    ];

    allowedUDPPorts = [
      # Minecraft Bedrock
      19132
    ];

    # Expose ports to libvirt guests
    interfaces."virbr0".allowedTCPPorts = [
      3890 # LDAP
    ];
  };

  # Fix for https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
