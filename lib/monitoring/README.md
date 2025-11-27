# Monitoring Template

This directory contains reusable helpers for adding Prometheus and Grafana monitoring to services.

## Usage

To add monitoring to a new service, follow this pattern in your service module:

```nix
{ config, lib, pkgs, ... }:
let
  # Import monitoring helpers
  monitoring = import ../../../lib/monitoring { inherit lib; };
  
  serviceName = "your-service-name";
  metricsPort = 8080; # Your service's metrics port
  metricsPath = "/metrics"; # Your service's metrics path
in {
  # Enable metrics in your service (service-specific)
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
        port = metricsPort; # Optional: only needed for HTTP-based alerts
      })
    ))
  ];
}
```

## Helper Functions

### `mkPrometheusScrape`

Creates a Prometheus scrape configuration.

**Parameters:**
- `jobName` (string): The job name for Prometheus
- `port` (int): The port where metrics are exposed
- `path` (string, optional): The metrics path (default: "/metrics")
- `labels` (attrset, optional): Additional labels to attach

### `mkServiceAlerts`

Creates Prometheus alerting rules for a service.

**Parameters:**
- `serviceName` (string): The name of the service
- `jobName` (string): The Prometheus job name
- `port` (int, optional): The service port (only needed for HTTP-based alerts)

**Alerts Created:**
- `{serviceName}_down`: Fires when the service is down for more than 1 minute
- `{serviceName}_high_response_time`: Fires when 95th percentile response time > 1s for 5 minutes (HTTP services only)
- `{serviceName}_high_error_rate`: Fires when error rate > 5% for 5 minutes (HTTP services only)

## Examples

See `modules/nixos/services/blocky/default.nix` and `modules/nixos/services/caddy/default.nix` for real-world examples.

