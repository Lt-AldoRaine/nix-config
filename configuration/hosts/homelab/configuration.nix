{ config, inputs, lib, ... }:
{
  imports = [
    # services
    ../../../modules/nixos/services/docker/default.nix
    ../../../modules/nixos/services/jellyfin/default.nix
    ../../../modules/nixos/services/tailscale/default.nix
    ../../../modules/nixos/services/caddy/default.nix
    ../../../modules/nixos/services/homepage/default.nix
    ../../../modules/nixos/services/prometheus/default.nix
    ../../../modules/nixos/services/grafana/default.nix
    ../../../modules/nixos/services/glance/default.nix
    ../../../modules/nixos/services/blocky/default.nix
    ../../../modules/nixos/services/authelia/default.nix
    ../../../modules/nixos/services/docker-containers/default.nix

    # system
    ../../../modules/nixos/system/nix/default.nix
    ../../../modules/nixos/system/fonts/default.nix
    ../../../modules/nixos/system/users/default.nix
    ../../../modules/nixos/system/utils/default.nix
    ../../../modules/nixos/system/timezone/default.nix
    ../../../modules/nixos/system/home-manager/default.nix
    ../../../modules/nixos/system/systemd-boot/default.nix
    ../../../modules/nixos/system/network-manager/default.nix
  ]
    ++ [
    ./secrets/default.nix

    ../../../themes/style/dracula.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  services.resolved.enable = lib.mkForce false;

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale-auth-key".path;
    useRoutingFeatures = "both";
  };

  services.my-caddy.enable = true;
  services.authelia.instances.main.enable = true;

  services.docker-containers.enable = true;
  services.docker-containers.minecraft = {
    enable = true;
    ops = [ "Lt_Ald0Raine" "AvrgAndy" ];
    curseforgeApiKeyFile = config.sops.secrets."curseforge-api-key".path;
  };

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.11";
}
