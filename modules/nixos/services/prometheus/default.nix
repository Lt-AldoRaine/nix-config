{ config, pkgs, lib, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9090;
    
    # Scrape configurations are empty here; 
    # other modules will add to this list via lib.mkMerge
    scrapeConfigs = [
    ];

    # Alerting rules directory - services can add rule files here
    ruleFiles = [];
  };

  # Enable Alertmanager for alert notifications
  services.prometheus.alertmanager = {
    enable = true;
    port = 9093;
    configuration = {
      route = {
        receiver = "default";
        group_by = [ "alertname" "cluster" "service" ];
        group_wait = "10s";
        group_interval = "10s";
        repeat_interval = "12h";
      };
      receivers = [
        {
          name = "default";
          # Add your notification channels here (email, Slack, etc.)
        }
      ];
    };
  };

  # Enable node_exporter for system metrics
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };

  # Enable blackbox exporter for HTTP health checks
  services.prometheus.exporters.blackbox = {
    enable = true;
    configFile = pkgs.writeText "blackbox.yml" ''
      modules:
        http_2xx:
          prober: http
          timeout: 5s
          http:
            valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
            valid_status_codes: [200, 301, 302]
            follow_redirects: true
    '';
    port = 9115;
  };
}

