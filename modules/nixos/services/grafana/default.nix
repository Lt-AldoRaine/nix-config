{ config, lib, pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.aldoraine.com";
        root_url = "https://grafana.aldoraine.com";
      };
    };

    # Provision Prometheus as a data source automatically
    provision = {
      enable = true;
      datasources.settings.datasources = [{
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = "http://localhost:${toString config.services.prometheus.port}";
        isDefault = true;
      }];

      # Provision dashboards
      dashboards.settings.providers = [{
        name = "Blocky";
        options = {
					path = ./dashboards;
				};
      }];
    };
  };

}
