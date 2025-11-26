{ config, pkgs, inputs, ... }: {
  imports = [
    ./variables.nix

    # programs
    ../../home/programs/git
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
			just
			ansible
			terraform
			nodejs

			dnsutils
			unixtools.netstat
			lm_sensors
    ];
    stateVersion = "24.11";
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
