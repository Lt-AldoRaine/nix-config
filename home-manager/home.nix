{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
