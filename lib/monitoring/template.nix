{ config, lib, pkgs, ... }:
let
  monitoring = import ../../../lib/monitoring { inherit lib; };
  
  serviceName = "your-service-name";
  metricsPort = 8080;
  metricsPath = "/metrics";
in {
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkPrometheusScrape {
        jobName = serviceName;
        port = metricsPort;
        path = metricsPath;
        labels = {
          service = serviceName;
        };
      })
    ]
  ];

  services.prometheus.ruleFiles = [
    (pkgs.writeText "${serviceName}-alerts.yml" (
      builtins.toJSON (monitoring.mkServiceAlerts {
        serviceName = serviceName;
        jobName = serviceName;
        port = metricsPort;
      })
    ))
  ];
}

