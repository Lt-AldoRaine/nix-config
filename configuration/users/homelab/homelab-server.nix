# #########################################################
# HOME-MANAGER - Homelab user configuration for homelab server
##########################################################
{ config, inputs, pkgs, lib, ... }:
{
  imports = [
    # Common tools and packages for homelab user
    ./commons.nix
  ];

  ###############################################################################
  # Server-specific packages
  ###############################################################################
  home.packages = with pkgs; [
    # Monitoring tools
    htop
    btop

    # Networking
    curl
    wget

    # Container tools
    lazydocker
  ];

  # Enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

