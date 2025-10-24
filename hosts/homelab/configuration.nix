{ config, ... }: {
  imports = [
    ../../nixos/system/default.nix
    ../../nixos/services/default.nix

    ../../themes/style/pandora.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.12";
}
