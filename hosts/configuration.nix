{ config, ... }: {
  imports = [
    ../nixos/nvidia.nix

    ../nixos/nix.nix
    ../nixos/audio.nix
    ../nixos/fonts.nix
    ../nixos/users.nix
    ../nixos/utils.nix
    ../nixos/timezone.nix
    ../nixos/bluetooth.nix
    ../nixos/xdg-portal.nix
    ../nixos/systemd-boot.nix
    ../nixos/home-manager.nix
    ../nixos/network-manager.nix
    ../nixos/variables-config.nix

    ../themes/style/shrineTheme.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.12";
}
