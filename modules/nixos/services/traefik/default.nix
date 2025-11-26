{ config, pkgs, lib, ... }:
let
  internalDomain =
    "homelab-server.tail426372.ts.net"; # Update this if your tailnet name changes

  # Helper to create a service that points to a specific URL
  mkService = url: { loadBalancer = { servers = [{ inherit url; }]; }; };

  # Helper to create a router that uses Tailscale for HTTPS
  mkRouter = { rule, service, middlewares ? [ ] }: {
    inherit rule service middlewares;
    entryPoints = [ "websecure" ];
    tls = {
      certResolver = "tailscale";
      domains = [{ main = internalDomain; }];
    };
  };

in {
  # Allow Traefik to request certificates from Tailscale
  services.tailscale.permitCertUid = "traefik";

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = { address = ":443"; };
      };

      certificatesResolvers = { tailscale.tailscale = { }; };

      api = {
        dashboard = true;
        insecure = false; # Do not expose dashboard on insecure port
      };

      # Enable providers if needed (e.g. Docker)
      providers.docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          # Dashboard router accessible via Tailscale
          dashboard = mkRouter {
            rule =
              "Host(`${internalDomain}`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
            service = "api@internal";
            middlewares = [ "auth" ];
          };

          # Example: Router for another service (e.g., Jellyfin)
          jellyfin = mkRouter {
            rule = "Host(`${internalDomain}`) && PathPrefix(`/jellyfin`)";
            service = "jellyfin";
            middlewares = [ "strip-jellyfin" ];
          };
        };

        middlewares = {
          # Basic auth middleware example (generated with htpasswd)
          # users: admin:$2y$05$j.3mDy9DjKZ7kOTrUzNfB.E/d3CFfgsoBu/2lHnTnjeopMMt3kiyK
          auth.basicAuth.users =
            [ "admin:$2y$05$j.3mDy9DjKZ7kOTrUzNfB.E/d3CFfgsoBu/2lHnTnjeopMMt3kiyK" ];

          # Strip prefix middleware for path-based routing
          strip-jellyfin.stripPrefix.prefixes = [ "/jellyfin" ];
        };

        services = {
          # Example service definition
          # jellyfin = mkService "http://127.0.0.1:8096";
          jellyfin = mkService "http://127.0.0.1:8096";
        };
      };
    };
  };

  # Open firewall ports for Traefik
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Add Traefik to the docker group so it can read the socket
  users.users.traefik.extraGroups = [ "docker" ];
}
