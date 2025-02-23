{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
    ../../home/system/wofi
    ../../home/system/hyprpanel
    ../../home/system/hyprland
    ../../home/system/hyprpaper

    # programs
    ../../home/programs/git
    ../../home/programs/kitty
    ../../home/programs/shell
    ../../home/programs/nvim
    ../../home/programs/thunar
    ../../home/programs/spicetify
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      discord
      steam

      go
      git
      nodejs
      python3

      libation
      zip
      unzip
      optipng
      pfetch
      pandoc
      ripgrep

      firefox
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
