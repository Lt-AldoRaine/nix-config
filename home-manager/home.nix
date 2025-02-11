{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home-manager
  ];

  home = {
    username = "connor";
    homeDirectory = "/home/connor";
    packages = with pkgs; [
      discord
      firefox
      git
      neovim
      zsh
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
