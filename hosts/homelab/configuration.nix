{ config, ... }: {
  imports = [
		# services
		../../nixos/services/docker/default.nix
		../../nixos/services/jellyfin/default.nix
		../../nixos/services/tailscale/default.nix
		../../nixos/services/blocky/default.nix
		../../nixos/services/homepage/default.nix

		# system
		../../nixos/system/nix/default.nix
		../../nixos/system/fonts/default.nix
		../../nixos/system/users/default.nix
		../../nixos/system/utils/default.nix
		../../nixos/system/timezone/default.nix
		../../nixos/system/home-manager/default.nix
		../../nixos/system/systemd-boot/default.nix
		../../nixos/system/network-manager/default.nix

    ../../themes/style/dracula.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.12";
}
