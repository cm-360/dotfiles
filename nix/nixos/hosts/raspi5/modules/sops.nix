{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = "${inputs.secrets}/sops/hosts/raspi5/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "hashed_passwords/root".neededForUsers = true;
      "hashed_passwords/cm360".neededForUsers = true;
    };
  };
}
