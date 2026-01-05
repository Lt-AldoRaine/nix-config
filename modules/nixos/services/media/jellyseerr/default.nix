{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../../lib/monitoring { inherit lib; };
  serviceName = "jellyseerr";
  servicePort = 5055;
in
{
  virtualisation.oci-containers.containers.jellyseerr = {
    image = "fallenbagel/jellyseerr:latest";
    autoStart = true;
    
    ports = [
      "5055:5055"
    ];
    
    volumes = [
      "/var/lib/jellyseerr:/app/config"
    ];
    
    environment = {
      TZ = "America/Chicago";
    };
  };

  networking.firewall.allowedTCPPorts = [ 5055 ];

  # Add Prometheus monitoring via HTTP check
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkPrometheusScrape {
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
      })
    ))
  ];
}


