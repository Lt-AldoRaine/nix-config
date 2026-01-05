{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../../lib/monitoring { inherit lib; };
  serviceName = "lidarr";
  servicePort = 8686;
in
{
  services.lidarr = {
    enable = true;
    dataDir = "/var/lib/lidarr";
    openFirewall = true;
    # Disable built-in authentication - Authelia handles it
    # This is configured via config.xml after first run
    # Set AuthenticationMethod to "None" in /var/lib/lidarr/config.xml
  };

  # Add Prometheus monitoring via blackbox exporter HTTP health check
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkBlackboxHttpCheck {
        jobName = serviceName;
        port = servicePort;
        path = "/";
        labels = {
          service = serviceName;
        };
      })
    ]
  ];

  # Add alerting rules
  services.prometheus.ruleFiles = [
    (pkgs.writeText "${serviceName}-alerts.yml" (
      builtins.toJSON (monitoring.mkServiceAlerts {
        serviceName = serviceName;
        jobName = serviceName;
        port = servicePort;
        useBlackbox = true;
      })
    ))
  ];
}


