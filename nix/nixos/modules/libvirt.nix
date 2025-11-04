{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;

      # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  # https://discourse.nixos.org/t/having-an-issue-with-virt-manager-not-allowing-usb-passthrough/6272
  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;
}
