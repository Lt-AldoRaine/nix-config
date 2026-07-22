{ config, ... }: {
  imports = [
		#services
		../../../modules/nixos/services/audio/default.nix
		../../../modules/nixos/services/bluetooth/default.nix
		../../../modules/nixos/services/lanzaboote/default.nix

		#system
		../../../modules/nixos/system/nix/default.nix
		../../../modules/nixos/system/fonts/default.nix
		../../../modules/nixos/system/users/default.nix
		../../../modules/nixos/system/utils/default.nix
		../../../modules/nixos/system/timezone/default.nix
		../../../modules/nixos/system/home-manager/default.nix
		../../../modules/nixos/system/systemd-boot/default.nix
		../../../modules/nixos/system/network-manager/default.nix
    ../../../modules/nixos/system/xdg-portal/default.nix
		../../../modules/nixos/system/nvidia/default.nix

    ../../../themes/style/shrineTheme.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;
	programs.hyprland.enable = true;

  system.stateVersion = "26.05";
}
