{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  serviceName = "jellyfin";
  servicePort = 8096;
in
{
	services.jellyfin = {
		enable = true;
		dataDir = "/var/lib/jellyfin";
		# Open firewall for web UI
		openFirewall = true;
	};

	# Custom CSS for Jellyfin
	# The CSS file is located at: ${./custom.css}
	# To apply it, go to Jellyfin Dashboard → General → Custom CSS
	# and paste the contents of the custom.css file
	# Alternatively, you can copy the file to /jellyfin/config/custom.css
	# and reference it in the Jellyfin web UI settings

	environment.systemPackages = [
		pkgs.jellyfin
		pkgs.jellyfin-web
		pkgs.jellyfin-ffmpeg
	];

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
