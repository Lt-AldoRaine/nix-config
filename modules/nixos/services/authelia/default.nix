{ config, pkgs, lib, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  cfg = config.services.authelia;
  serviceName = "authelia";
  httpPort = 9091;
in {
  options.services.authelia = {
    enable = lib.mkEnableOption "Authelia authentication server";
  };

  config = lib.mkIf cfg.enable {
    services.authelia = {
      enable = true;
      secrets = {
        jwtSecretFile = "/var/lib/authelia/jwt_secret";
        sessionSecretFile = "/var/lib/authelia/session_secret";
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
            path = "/var/lib/authelia/users_database.yml";
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
            path = "/var/lib/authelia/db.sqlite3";
          };
        };
        notifier = {
          filesystem = {
            filename = "/var/lib/authelia/notification.txt";
          };
        };
      };
    };

    systemd.services.authelia.serviceConfig = {
      StateDirectory = "authelia";
      StateDirectoryMode = "0750";
    };

    services.prometheus.scrapeConfigs = lib.mkMerge [
      [
        (monitoring.mkPrometheusScrape {
          jobName = serviceName;
          port = httpPort;
          path = "/api/metrics";
          labels = {
            service = serviceName;
          };
        })
      ]
    ];
  };
}

