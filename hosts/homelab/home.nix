{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
    #../../home/system/wofi
    #../../home/system/hyprpanel
    #../../home/system/hyprland

    # programs
    ../../home/programs/git
    ../../home/programs/kitty
    ../../home/programs/shell
    ../../home/programs/nvim
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;


    packages = with pkgs; [
      git

      zip
      unzip
      pfetch
      ripgrep

			dnsutils
			unixtools.netstat
			lm_sensors
			discord
      firefox
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
