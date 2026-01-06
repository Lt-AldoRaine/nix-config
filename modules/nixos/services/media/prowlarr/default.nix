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
  };

  # Add Prometheus monitoring via HTTP check
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkPrometheusScrape {
        jobName = serviceName;
        port = servicePort;
        path = "/api/v1/system/status";
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


