{ config, ... }: {
  imports = [
		#services
		../../nixos/services/audio/default.nix
		../../nixos/services/bluetooth/default.nix

		#system
		../../nixos/system/nix/default.nix
		../../nixos/system/fonts/default.nix
		../../nixos/system/users/default.nix
		../../nixos/system/utils/default.nix
		../../nixos/system/timezone/default.nix
		../../nixos/system/home-manager/default.nix
		../../nixos/system/systemd-boot/default.nix
		../../nixos/system/network-manager/default.nix
    ../../nixos/system/xdg-portal/default.nix

    ../../themes/style/dracula.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.11";
}
