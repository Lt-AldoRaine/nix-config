{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../../lib/monitoring { inherit lib; };
  mullvadEnabled = config.services.mullvad-vpn.enable or false;
  # Mullvad typically uses wg-mullvad interface for WireGuard
  mullvadInterface = "wg-mullvad";
  serviceName = "qbittorrent";
  servicePort = 8080;
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
      Preferences = {
        Connection = {
          Interface = mullvadInterface;
          InterfaceName = mullvadInterface;
        };
        WebUI = {
          Enabled = true;
        };
      };
    };
  };

  # Ensure qbittorrent starts after mullvad-vpn service
  systemd.services.qbittorrent = lib.mkIf mullvadEnabled {
    after = [ "mullvad-vpn.service" "network-online.target" ];
    wants = [ "mullvad-vpn.service" ];
  };

  # Add Prometheus monitoring via HTTP check
  services.prometheus.scrapeConfigs = lib.mkMerge [
    (lib.mkIf mullvadEnabled [
      (monitoring.mkPrometheusScrape {
        jobName = serviceName;
        port = servicePort;
        path = "/";
        labels = {
          service = serviceName;
        };
      })
    ])
  ];

  # Add alerting rules
  services.prometheus.ruleFiles = lib.mkIf mullvadEnabled [
    (pkgs.writeText "${serviceName}-alerts.yml" (
      builtins.toJSON (monitoring.mkServiceAlerts {
        serviceName = serviceName;
        jobName = serviceName;
        port = servicePort;
      })
    ))
  ];
}

