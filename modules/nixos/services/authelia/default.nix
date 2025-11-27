{ config, pkgs, lib, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  instanceName = "main";
  serviceName = "authelia";
  httpPort = 9091;
in {
  config = {
    services.authelia.instances.${instanceName} = {
      secrets = {
        jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
        storageEncryptionKeyFile = config.age.secrets."authelia-storage-encryption-key".path;
      };
      settings = {
        server = {
          host = "127.0.0.1";
          port = httpPort;
          path = "api";
        };
        theme = "dark";
        log = {
          level = "info";
        };
        default_redirection_url = "https://auth.aldoraine.com";
        authentication_backend = {
          file = {
            path = "/var/lib/authelia-${instanceName}/users_database.yml";
            password = {
              algorithm = "argon2";
              iterations = 1;
              salt_length = 16;
              parallelism = 8;
              memory = 64;
            };
          };
        };
        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = "*.aldoraine.com";
              policy = "bypass";
            }
            {
              domain = "auth.aldoraine.com";
              policy = "bypass";
            }
          ];
        };
        session = {
          name = "authelia_session";
          expiration = "1h";
          inactivity = "5m";
          remember_me_duration = "1M";
          domain = "aldoraine.com";
        };
        regulation = {
          max_retries = 3;
          find_time = "2m";
          ban_time = "5m";
        };
        storage = {
          local = {
            path = "/var/lib/authelia-${instanceName}/db.sqlite3";
          };
        };
        notifier = {
          filesystem = {
            filename = "/var/lib/authelia-${instanceName}/notification.txt";
          };
        };
      };
    };

    systemd.services."authelia-${instanceName}".serviceConfig = {
      StateDirectory = "authelia-${instanceName}";
      StateDirectoryMode = "0750";
    };

    services.prometheus.scrapeConfigs = lib.mkMerge [
      (lib.mkIf config.services.authelia.instances.${instanceName}.enable [
        (monitoring.mkPrometheusScrape {
          jobName = serviceName;
          port = httpPort;
          path = "/api/metrics";
          labels = {
            service = serviceName;
          };
        })
      ])
    ];
  };
}

