{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../../lib/monitoring { inherit lib; };
  serviceName = "sonarr";
  servicePort = 8989;
in
{
  services.sonarr = {
    enable = true;
    dataDir = "/var/lib/sonarr";
    openFirewall = true;
  };

  # Add Prometheus monitoring via HTTP check
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkPrometheusScrape {
        jobName = serviceName;
        port = servicePort;
        path = "/api/v3/system/status";
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
      })
    ))
  ];
}


