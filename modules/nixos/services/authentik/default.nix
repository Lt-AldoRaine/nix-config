{ config, pkgs, lib, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  cfg = config.services.authentik;
  serviceName = "authentik";
  httpPort = 9000;
  httpsPort = 9443;
in {
  options.services.authentik = {
    enable = lib.mkEnableOption "Authentik identity provider";
    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to file containing the secret key (from agenix)";
      default = config.age.secrets."authentik-secret-key".path;
    };
  };

  config = lib.mkIf cfg.enable {
    # Use agenix secret for Authentik secret key
    age.secrets."authentik-secret-key" = {
      file = ../../../../hosts/homelab/secrets/authentik-secret-key.age;
      owner = "root";
      group = "root";
      mode = "600";
    };
    # Authentik requires PostgreSQL
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "authentik" ];
      ensureUsers = [
        {
          name = "authentik";
          ensureDBOwnership = true;
        }
      ];
    };

    # Authentik requires Redis
    services.redis.servers.authentik = {
      enable = true;
      port = 6379;
    };

    # Enable OCI containers (Docker/Podman)
    virtualisation.oci-containers.backend = "docker";

    # Run Authentik server
    virtualisation.oci-containers.containers.authentik-server = {
      image = "ghcr.io/goauthentik/authentik:2024.2.5";
      environment = {
        AUTHENTIK_SECRET_KEY_FILE = "/secret_key";
        AUTHENTIK_POSTGRESQL__HOST = "host.docker.internal";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_REDIS__HOST = "host.docker.internal";
        AUTHENTIK_REDIS__PORT = "6379";
      };
      volumes = [
        "${cfg.secretKeyFile}:/secret_key:ro"
        "/var/lib/authentik/media:/media"
        "/var/lib/authentik/certs:/certs"
      ];
      ports = {
        "${toString httpPort}" = httpPort; # HTTP
        "${toString httpsPort}" = httpsPort; # HTTPS
      };
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
      ];
    };

    # Run Authentik worker
    virtualisation.oci-containers.containers.authentik-worker = {
      image = "ghcr.io/goauthentik/authentik:2024.2.5";
      cmd = [ "worker" ];
      environment = {
        AUTHENTIK_SECRET_KEY_FILE = "/secret_key";
        AUTHENTIK_POSTGRESQL__HOST = "host.docker.internal";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_REDIS__HOST = "host.docker.internal";
        AUTHENTIK_REDIS__PORT = "6379";
      };
      volumes = [
        "${cfg.secretKeyFile}:/secret_key:ro"
        "/var/lib/authentik/media:/media"
        "/var/lib/authentik/certs:/certs"
      ];
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
      ];
    };

    # Add Authentik to Prometheus scrape targets (if metrics are enabled)
    # Note: Authentik doesn't expose Prometheus metrics by default, but you can enable it
    services.prometheus.scrapeConfigs = lib.mkMerge [
      [
        (monitoring.mkPrometheusScrape {
          jobName = serviceName;
          port = httpPort;
          path = "/metrics";
          labels = {
            service = serviceName;
          };
        })
      ]
    ];
  };
}

