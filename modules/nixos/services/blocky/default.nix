{ lib, pkgs, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  dnsPort = 53;
  loopbackResolvers = [ "127.0.0.1" "::1" ];
  serviceName = "blocky";
  metricsPort = 4000;
in {
  networking = {
    nameservers = lib.mkForce loopbackResolvers;
    networkmanager.dns = "none";
    firewall = {
      allowedTCPPorts = lib.mkAfter [ dnsPort ];
      allowedUDPPorts = lib.mkAfter [ dnsPort ];
    };
  };

  services.blocky = {
    enable = true;
    settings = {
      bootstrapDns = [ "9.9.9.9" "1.1.1.1" ];
      ports.dns = dnsPort;
      ports.http = metricsPort; # Enable HTTP port for metrics
      
      prometheus = {
        enable = true;
        path = "/metrics";
      };

      upstreams.groups.default = [
        "9.9.9.9"
        "149.112.112.112"
        "https://dns.quad9.net/dns-query"
        "tcp-tls:dns.quad9.net"
      ];

      blocking = {
        denylists = {
          ads = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
						"https://adaway.org/hosts.txt"
						"https://v.firebog.net/hosts/AdguardDNS.txt"
          ];
          threats = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.txt"
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/dyndns.txt"
          ];

					trackers = [
						"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/native.apple.txt"
						"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/native.samsung.txt"
						"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/native.lgwebos.txt"
						"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/native.amazon.txt"
					];

          fakenews = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-only/hosts"
          ];
          gambling = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-only/hosts"
          ];
          adult = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
          ];

        };

        clientGroupsBlock.default = [ "ads" "adult" "fakenews" "gambling" "trackers"  "threats" ];
      };
    };
  };

  # Add Blocky to Prometheus scrape targets using monitoring helper
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [
      (monitoring.mkPrometheusScrape {
        jobName = serviceName;
        port = metricsPort;
        path = "/metrics";
        labels = {
          service = serviceName;
        };
      })
    ]
  ];

  # Add alerting rules for Blocky
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
