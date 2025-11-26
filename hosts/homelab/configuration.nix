{ config, ... }: {
  imports = [
    # services
    ../../modules/nixos/services/docker/default.nix
    ../../modules/nixos/services/jellyfin/default.nix
    ../../modules/nixos/services/tailscale/default.nix
    ../../modules/nixos/services/homepage/default.nix
    ../../modules/nixos/services/glance/default.nix
    ../../modules/nixos/services/blocky/default.nix

    # system
    ../../modules/nixos/system/nix/default.nix
    ../../modules/nixos/system/fonts/default.nix
    ../../modules/nixos/system/users/default.nix
    ../../modules/nixos/system/utils/default.nix
    ../../modules/nixos/system/timezone/default.nix
    ../../modules/nixos/system/home-manager/default.nix
    ../../modules/nixos/system/systemd-boot/default.nix
    ../../modules/nixos/system/network-manager/default.nix

    ../../themes/style/dracula.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];
	 
  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.11";
}
