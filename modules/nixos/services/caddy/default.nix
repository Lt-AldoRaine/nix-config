{ config, pkgs, lib, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  cfg = config.services.my-caddy;
  
  # Define your base domain here
  baseDomain = "aldoraine.com";
  serviceName = "caddy";
  metricsPort = 2019; # Caddy admin API port
in {
  options.services.my-caddy = {
    enable = lib.mkEnableOption "Caddy web server";
    email = lib.mkOption {
      type = lib.types.str;
      default = "cpenn@aldoraine.com";
      description = "Email for ACME registration";
    };
  };

  config = lib.mkIf cfg.enable {
    # Open ports
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 443 ];

    services.caddy = {
      enable = true;
      email = cfg.email;

      # Load Cloudflare token from agenix secret
      environmentFile = config.age.secrets."cloudflare-api-token".path;

      # Use a package that includes the Cloudflare DNS plugin
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
        hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U="; # We need to let Nix build this once to get the hash
      };

      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
        
        # Enable metrics
        servers {
          metrics
        }
      '';

      virtualHosts = {
        # Wildcard subdomain handling
        "*.${baseDomain}" = {
          extraConfig = ''
            tls {
              dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
            }

            @jellyfin host jellyfin.${baseDomain}
            handle @jellyfin {
              reverse_proxy localhost:8096
            }

						@dash host dash.${baseDomain}
						handle @dash {
              forward_auth http://localhost:9091 {
                uri /api/verify?rd=https://auth.${baseDomain}
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
              }
							reverse_proxy localhost:8282
						}

						@prometheus host prometheus.${baseDomain}
						handle @prometheus {
              forward_auth http://localhost:9091 {
                uri /api/verify?rd=https://auth.${baseDomain}
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
              }
							reverse_proxy localhost:9090
						}
            
            @grafana host grafana.${baseDomain}
            handle @grafana {
              forward_auth http://localhost:9091 {
                uri /api/verify?rd=https://auth.${baseDomain}
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
              }
              reverse_proxy localhost:3000
            }

            @authelia host auth.${baseDomain}
            handle @authelia {
              reverse_proxy localhost:9091
            }

            # Media services (no Authelia - use built-in auth)
            @lidarr host lidarr.${baseDomain}
            handle @lidarr {
              reverse_proxy localhost:8686
            }

            @radarr host radarr.${baseDomain}
            handle @radarr {
              reverse_proxy localhost:7878
            }

            @sonarr host sonarr.${baseDomain}
            handle @sonarr {
              reverse_proxy localhost:8989
            }

            @prowlarr host prowlarr.${baseDomain}
            handle @prowlarr {
              reverse_proxy localhost:9696
            }

            @jellyseerr host jellyseerr.${baseDomain}
            handle @jellyseerr {
              reverse_proxy localhost:5055
            }

            @qbittorrent host qbittorrent.${baseDomain}
            handle @qbittorrent {
              reverse_proxy localhost:8080
            }

            @sab host sab.${baseDomain}
            handle @sab {
              forward_auth http://localhost:9091 {
                uri /api/verify?rd=https://auth.${baseDomain}
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
              }
              reverse_proxy localhost:8085
            }
            
            # Fallback for unknown subdomains
            handle {
              respond "Service not found" 404
            }
          '';
        };
      };
    };
    
    # Add Caddy to Prometheus scrape targets using monitoring helper
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

    # Add alerting rules for Caddy
    services.prometheus.ruleFiles = [
      (pkgs.writeText "${serviceName}-alerts.yml" (
        builtins.toJSON (monitoring.mkServiceAlerts {
          serviceName = serviceName;
          jobName = serviceName;
          port = metricsPort;
        })
      ))
    ];
  };
}
