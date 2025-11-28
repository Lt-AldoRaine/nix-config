{ config, pkgs, inputs, ... }:
let
  inherit (inputs.self.homeManagerModules) programs system;
in
{
  imports =
    [
      ./variables.nix
    ]
    ++ (with system; [
      wofi
      hyprpanel
      hyprland
      hyprpaper
    ])
    ++ (with programs; [
      git
      kitty
      shell
      nvim
      thunar
      spicetify
    ]);

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
