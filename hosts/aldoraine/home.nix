{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
    ../../modules/home/system/wofi
    ../../modules/home/system/hyprpanel
    ../../modules/home/system/hyprland
    ../../modules/home/system/hyprpaper

    # programs
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/shell
    ../../modules/home/programs/nvim
    ../../modules/home/programs/thunar
    ../../modules/home/programs/spicetify
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      discord
      steam
			noisetorch

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
