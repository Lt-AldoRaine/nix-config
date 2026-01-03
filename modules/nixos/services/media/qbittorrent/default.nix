{ config, pkgs, lib, ... }:

let
  mullvadEnabled = config.services.mullvad-vpn.enable or false;
  # Mullvad typically uses wg-mullvad interface for WireGuard
  mullvadInterface = "wg-mullvad";
in
{
  # Only enable qbittorrent if mullvad-vpn is enabled
  services.qbittorrent = lib.mkIf mullvadEnabled {
    enable = true;
    profileDir = "/var/lib/qbittorrent";
    openFirewall = true;
    webuiPort = 8080;
    
    # Configure qbittorrent to bind to Mullvad interface via serverConfig
    # This ensures traffic only goes through VPN
    serverConfig = {
      "Connection\\Interface" = mullvadInterface;
      "Connection\\InterfaceName" = mullvadInterface;
      # Enable web UI
      "Preferences\\WebUI\\Enabled" = true;
    };
  };

  # Ensure qbittorrent starts after mullvad-vpn service
  systemd.services.qbittorrent = lib.mkIf mullvadEnabled {
    after = [ "mullvad-vpn.service" "network-online.target" ];
    wants = [ "mullvad-vpn.service" ];
  };
}

