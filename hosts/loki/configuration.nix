{ config, ... }: {
  imports = [
		# services
		../../nixos/services/tailscale/default.nix
		../../nixos/services/traefik/default.nix

		# system
		../../nixos/system/nix/default.nix
		../../nixos/system/fonts/default.nix
		../../nixos/system/users/default.nix
		../../nixos/system/utils/default.nix
		../../nixos/system/timezone/default.nix
		../../nixos/system/home-manager/default.nix
		../../nixos/system/network-manager/default.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.12";
}
