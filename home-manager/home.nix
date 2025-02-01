{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home-manager/shell/zsh.nix
    ../modules/home-manager/style/stylixUser.nix
    ../modules/home-manager/alacritty.nix
    ../modules/home-manager/shell/starship.nix
    ../modules/home-manager/git.nix
  ];

  home = {
    username = "connor";
    homeDirectory = "/home/connor";
    packages = with pkgs; [
      git
      firefox
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
