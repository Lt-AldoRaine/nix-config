{ config, pkgs, lib, ... }: {
  services.prometheus = {
    enable = true;
    port = 9090;
    
    # Scrape configurations are empty here; 
    # other modules will add to this list via lib.mkMerge or extraScrapeConfigs
    scrapeConfigs = [
    ];
  };

  # Enable node_exporter for system metrics
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };
}

