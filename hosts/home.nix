{ config, pkgs, ... }: {
  imports = [
    ./variables.nix

    # system
		./home/system

    # programs
		./home/programs
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
