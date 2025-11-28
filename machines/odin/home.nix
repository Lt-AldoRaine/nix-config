{ config, pkgs, inputs, ... }:
let
  inherit (inputs.self.homeManagerModules) programs;
in
{
  imports =
    [
      ./variables.nix
    ]
    ++ (with programs; [
      git
      shell
      nvim
    ]);

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/${config.var.username}";

    packages = with pkgs; [
      git
      ripgrep
      zip
      unzip
      inputs.agenix.packages.${pkgs.system}.default
    ];
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}

