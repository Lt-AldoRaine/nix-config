{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
    ../home/system/wofi
	../home/system/hyprpanel
    ../home/system/hyprland
	../home/system/hyprpaper

	../home/scripts

    # programs
    ../home/programs/git
    ../home/programs/kitty
    ../home/programs/shell
    ../home/programs/nvim
	../home/programs/thunar
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      discord

      go
      git
      nodejs
      python3

      zip
      unzip
      optipng
      pfetch
      pandoc
      curtail
	  swww

      firefox
      neovim
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
