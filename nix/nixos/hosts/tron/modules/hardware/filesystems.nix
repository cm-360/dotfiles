{
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption
  # https://wiki.archlinux.org/title/Dm-crypt/Device_encryption
  # https://www.man7.org/linux/man-pages/man5/crypttab.5.html
  # https://gist.github.com/MaxXor/ba1665f47d56c24018a943bb114640d7
  environment.etc."crypttab" = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      cryptdata0  UUID=4368b300-921a-462b-bdc3-79259eca4615 /etc/cryptdata.key   luks,discard,nofail
      cryptdata1  UUID=5ae6aa77-f597-4c55-8dbb-f36b3c044689 /etc/cryptdata.key   luks,discard,nofail
      cryptexthdd UUID=f4e09e88-2ac4-4470-9c5f-6944e87fe0be /etc/cryptexthdd.key luks,nofail
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/tmp" = {
      device = "none";
      fsType = "tmpfs";
    };

    "/data" = {
      device = "/dev/vg-data/data";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

    "/virt" = {
      device = "/dev/vg-data/virt";
      fsType = "ext4";
      options = [ "nofail" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/7ebd52fa-3039-4809-b7d4-db2eb60f813b";
      randomEncryption.enable = true;
    }
  ];
}
