{ config, inputs, ... }:
{
  imports = [
    # services
    ../../modules/nixos/services/audio/default.nix
    ../../modules/nixos/services/bluetooth/default.nix

    # system
    ../../modules/nixos/system/nix/default.nix
    ../../modules/nixos/system/fonts/default.nix
    ../../modules/nixos/system/users/default.nix
    ../../modules/nixos/system/utils/default.nix
    ../../modules/nixos/system/timezone/default.nix
    ../../modules/nixos/system/home-manager/default.nix
    ../../modules/nixos/system/systemd-boot/default.nix
    ../../modules/nixos/system/network-manager/default.nix
    ../../modules/nixos/system/xdg-portal/default.nix
  ]
    ++ [
      ../../themes/style/dracula.nix

      ./hardware-configuration.nix
      ./variables.nix
    ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.11";
}
