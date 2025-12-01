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
      ../../modules/nixos/system/network-manager/default.nix

      ./disko.nix
      ./hardware-configuration.nix
      ./variables.nix
      ./deploy.nix
      ../../themes/style/dracula.nix
      ../../hosts/homelab/secrets/default.nix
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
          targets = [ "homelab-server:9100" ];
          labels = { host = "homelab"; };
        }];
      }
      {
        job_name = "caddy-homelab";
        static_configs = [{
          targets = [ "homelab-server:2019" ];
          labels = {
            service = "caddy";
            host = "homelab";
          };
        }];
        metrics_path = "/metrics";
      }
    ];

    # Tailscale configuration with automatic authentication
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      # Auth key from sops secrets for automatic Tailscale login
      authKeyFile = config.sops.secrets."tailscale-auth-key".path;

    };
  };

  # Set hostname for Tailscale network
  networking.hostName = "odin";

  # Clan target host - use Tailscale hostname after initial setup
  # After first deployment, SSH is only accessible via Tailscale
  clan.core.networking.targetHost = "root@odin";

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  home-manager.users."${config.var.username}" = {
    imports = [ ./home.nix ];
  };

  system.stateVersion = "24.11";
}
