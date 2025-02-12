{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
    ../home/system/wofi
    # ../home/system/waybar
	../home/system/hyprpanel
    ../home/system/hyprland

    # programs
    ../home/programs/git
    ../home/programs/kitty
    ../home/programs/shell
    ../home/programs/nixvim-config
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
      btop
      textpieces
      curtail

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
