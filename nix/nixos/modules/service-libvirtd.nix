{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };

      # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  users.users.cm360.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;
}
