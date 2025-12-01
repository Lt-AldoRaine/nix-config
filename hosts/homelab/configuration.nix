{ config, inputs, ... }:
{
  imports = [
    # services
    ../../modules/nixos/services/docker/default.nix
    ../../modules/nixos/services/jellyfin/default.nix
    ../../modules/nixos/services/tailscale/default.nix
    ../../modules/nixos/services/caddy/default.nix
    ../../modules/nixos/services/homepage/default.nix
    ../../modules/nixos/services/prometheus/default.nix
    ../../modules/nixos/services/grafana/default.nix
    ../../modules/nixos/services/glance/default.nix
    ../../modules/nixos/services/blocky/default.nix
    ../../modules/nixos/services/authelia/default.nix
    ../../modules/nixos/services/docker-containers/default.nix

    # system
    ../../modules/nixos/system/nix/default.nix
    ../../modules/nixos/system/fonts/default.nix
    ../../modules/nixos/system/users/default.nix
    ../../modules/nixos/system/utils/default.nix
    ../../modules/nixos/system/timezone/default.nix
    ../../modules/nixos/system/home-manager/default.nix
    ../../modules/nixos/system/systemd-boot/default.nix
    ../../modules/nixos/system/network-manager/default.nix
  ]
    ++ [
    inputs.agenix.nixosModules.age

    ../../themes/style/dracula.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];
	 
  services.my-caddy.enable = true;
  services.authelia.instances.main.enable = true;
  
  services.docker-containers.enable = true;
  services.docker-containers.minecraft = {
    enable = true;
    ops = [ "Lt_Ald0Raine" "AvrgAndy" ];
    curseforgeApiKeyFile = config.age.secrets."curseforge-api-key".path;
  };

  age.secrets."cloudflare-api-token" = {
    file = ./secrets/cloudflare-api-token.age;
    owner = "caddy";
    group = "caddy";
    mode = "600";
  };

  age.secrets."authelia-jwt-secret" = {
    file = ./secrets/authelia-jwt-secret.age;
    owner = "authelia-main";
    group = "authelia-main";
    mode = "600";
  };

  age.secrets."authelia-storage-encryption-key" = {
    file = ./secrets/authelia-storage-encryption-key.age;
    owner = "authelia-main";
    group = "authelia-main";
    mode = "600";
  };

  age.secrets."curseforge-api-key" = {
    file = ./secrets/curseforge-api-key.age;
    owner = "root";
    group = "root";
    mode = "600";
  };
	 
  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.11";
}
