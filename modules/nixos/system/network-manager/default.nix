{
  networking = {
		networkmanager.enable = true;
		networkmanager.dns = "none";
	};
  systemd.services.NetworkManager-wait-online.enable = false;
}
