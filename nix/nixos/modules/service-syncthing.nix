{
  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [
# 	8384	# Web GUI
	22000	# Sync traffic
  ];
  networking.firewall.allowedUDPPorts = [
	22000	# Sync traffic
	21027	# Discovery
  ];
}
