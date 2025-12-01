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
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      git

      zip
      unzip
      pfetch
      ripgrep
			ansible
			nodejs

			lm_sensors
      inputs.agenix.packages.${pkgs.system}.default
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
