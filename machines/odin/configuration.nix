{ config, lib, inputs, self, ... }:
{
  imports =
    [
      ../../modules/nixos/services/tailscale/default.nix
      ../../modules/nixos/services/caddy/default.nix
      ../../modules/nixos/services/prometheus/default.nix
      ../../modules/nixos/services/grafana/default.nix
      ../../modules/nixos/services/authelia/default.nix
      ../../modules/nixos/services/homepage/default.nix

      ../../modules/nixos/system/nix/default.nix
      ../../modules/nixos/system/fonts/default.nix
      ../../modules/nixos/system/users/default.nix
      ../../modules/nixos/system/utils/default.nix
      ../../modules/nixos/system/timezone/default.nix
      ../../modules/nixos/system/home-manager/default.nix
      ../../modules/nixos/system/systemd-boot/default.nix
      ../../modules/nixos/system/network-manager/default.nix

      ./disko.nix
      ./hardware-configuration.nix
      ./variables.nix
      ./deploy.nix
      ../../themes/style/dracula.nix
    ];

  services = {
    my-caddy.enable = true;
    authelia.instances.main.enable = true;

    prometheus.scrapeConfigs = [
      {
        job_name = "node-exporter-odin";
        static_configs = [{
          targets = [ "localhost:9100" ];
          labels = { host = "odin"; };
        }];
      }
      {
        job_name = "node-exporter-homelab";
        static_configs = [{
          targets = [ "homelab:9100" ];
          labels = { host = "homelab"; };
        }];
      }
      {
        job_name = "caddy-homelab";
        static_configs = [{
          targets = [ "homelab:2019" ];
          labels = {
            service = "caddy";
            host = "homelab";
          };
        }];
        metrics_path = "/metrics";
      }
    ];

    tailscale.useRoutingFeatures = "both";
  };

  clan.core.networking.targetHost = "root@odin";
  age.secrets = {
    "authelia-jwt-secret" = {
      file = ../../hosts/homelab/secrets/authelia-jwt-secret.age;
      owner = "authelia-main";
      group = "authelia-main";
      mode = "600";
    };

    "authelia-storage-encryption-key" = {
      file = ../../hosts/homelab/secrets/authelia-storage-encryption-key.age;
      owner = "authelia-main";
      group = "authelia-main";
      mode = "600";
    };

    "cloudflare-api-token" = {
      file = ../../hosts/homelab/secrets/cloudflare-api-token.age;
      owner = "caddy";
      group = "caddy";
      mode = "600";
    };

    "tailscale-auth-key" = {
      file = ../../hosts/homelab/secrets/terraform/odin/tailscale-auth-key.age;
      owner = "root";
      group = "root";
      mode = "600";
    };
  };

  services.tailscale.authKeyFile = config.age.secrets."tailscale-auth-key".path;

  home-manager.users."${config.var.username}" = {
    imports = [ ./home.nix ];
  };

  system.stateVersion = "24.11";
}
