# Template for adding Prometheus monitoring to a service
# Copy this pattern into your service module

{ config, lib, pkgs, ... }:
let
  # Import monitoring helpers
  monitoring = import ../../../lib/monitoring { inherit lib; };
  
  serviceName = "your-service-name";
  metricsPort = 8080; # Change to your service's metrics port
  metricsPath = "/metrics"; # Change if your service uses a different path
in {
  # Enable metrics endpoint in your service (example)
  # services.your-service.metrics.enable = true;
  # services.your-service.metrics.port = metricsPort;

  # Add Prometheus scraping for this service
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

  # Add alerting rules for this service
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

