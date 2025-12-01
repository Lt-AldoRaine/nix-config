{ config, pkgs, inputs, ... }:
let
  homeModulesDir = ../../modules/home/programs;
in
{
  imports = [
    ./variables.nix
    (homeModulesDir + "/git/default.nix")
    (homeModulesDir + "/shell/default.nix")
    (homeModulesDir + "/nvim/default.nix")
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/${config.var.username}";

    packages = with pkgs; [
      git
      ripgrep
      zip
      unzip
    ];
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}

