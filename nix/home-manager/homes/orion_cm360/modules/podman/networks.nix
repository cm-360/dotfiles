{ inputs, ... }:
{
  services.podman.networks = {
    ldap = {
      driver = "bridge";
      description = "Podman LDAP network";
      subnet = inputs.secrets.podman.networks.ldap.subnet;
    };

    proxy = {
      driver = "bridge";
      description = "Podman proxy network";
      subnet = inputs.secrets.podman.networks.proxy.subnet;
    };
  };
}
