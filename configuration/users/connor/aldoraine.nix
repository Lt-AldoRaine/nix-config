# #########################################################
# HOME-MANAGER - Connor user configuration for aldoraine
##########################################################
{ config, inputs, pkgs, lib, ... }: {
  imports = [
    # Common tools and packages for connor user
    ./commons.nix

    # Desktop environment
    ../../../modules/home/system/wofi/default.nix
    ../../../modules/home/system/hyprpanel/default.nix
    ../../../modules/home/system/hyprland/default.nix
    ../../../modules/home/system/hyprpaper/default.nix

    # Programs
    ../../../modules/home/programs/kitty/default.nix
    ../../../modules/home/programs/thunar/default.nix
    ../../../modules/home/programs/spicetify/default.nix
  ];

  ###############################################################################
  # Desktop-specific packages
  ###############################################################################
  home.packages = with pkgs; [
    # Communication
    discord

    # Gaming
    steam

    # Audio
    noisetorch

    # Development
    go
    python3

    # Media
    libation

    # Utilities
    optipng
    pandoc

    # Browser
    firefox
  ];

  # Enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======


>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
