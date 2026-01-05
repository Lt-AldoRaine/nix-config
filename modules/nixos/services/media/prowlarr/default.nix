{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../../lib/monitoring { inherit lib; };
  serviceName = "prowlarr";
  servicePort = 9696;
in
{
  services.prowlarr = {
    enable = true;
    dataDir = "/var/lib/prowlarr";
    openFirewall = true;
    # Disable built-in authentication - Authelia handles it
    # This is configured via config.xml after first run
    # Set AuthenticationMethod to "None" in /var/lib/prowlarr/config.xml
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


