{ config, pkgs, lib, ... }:
let
  cfg = config.services.my-caddy;
  
  # Define your base domain here
  baseDomain = "aldoraine.com";
in {
  options.services.my-caddy = {
    enable = lib.mkEnableOption "Caddy web server";
    email = lib.mkOption {
      type = lib.types.str;
      default = "harambefallon@gmail.com";
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

      # Load Cloudflare token for DNS challenge
      environmentFile = "/home/connor/nix-config/hosts/homelab/secrets/cloudflare_caddy.env";

      # Use a package that includes the Cloudflare DNS plugin
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
        hash = "sha256-4qUWhrv3/8BtNCi48kk4ZvbMckh/cGRL7k+MFvXKbTw="; # We need to let Nix build this once to get the hash
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
							reverse_proxy localhost:8282
						}

						@prometheus host prometheus.${baseDomain}
						handle @prometheus {
							reverse_proxy localhost:9090
						}
            
            @grafana host grafana.${baseDomain}
            handle @grafana {
              reverse_proxy localhost:3000
            }

            # Add other services here
            # @sonarr host sonarr.${baseDomain}
            # handle @sonarr {
            #   reverse_proxy localhost:8989
            # }
            
            # Fallback for unknown subdomains
            handle {
              respond "Service not found" 404
            }
          '';
        };
      };
    };
    
    # Add Caddy to Prometheus scrape targets
    services.prometheus.scrapeConfigs = [
      {
        job_name = "caddy";
        static_configs = [{
          targets = [ "localhost:2019" ];
        }];
      }
    ];
  };
}
