{
  inputs,
  username,
  password,
  desktop ? "gnome",
}: system: let
    configuration = import ./nixos/configuration.nix;
    hardware-configuration = import ./nixos/hardware-configuration.nix;
    home-manager = import ./home-manager/home.nix;

    pkgs = inputs.nixpkgs.legacyPackages.${system};

    enabledDesktopGnome = desktop == "gnome";

  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
	hardware-configuration
	configuration

	{
          environment.systemPackages = with pkgs; [
            git
	    gcc
	    neofetch
	    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
	    neovim
	    wget
	  ];

	  services.xserver.displayManager.autoLogin.user = username;

	  services.xserver.desktopManager.gnome.enable = enabledDesktopGnome;
	  # services.xserver.desktopManager.gdm.enable = enabledDesktopGnome;

	  users.users."${username}" = {
	    home = "/home/${username}";
	    isNormalUser = true;
	    password = password;
	    shell = pkgs.zsh;
	    extraGroups = [ "wheel" ];
	  };
	}

	  inputs.home-manager.nixosModules.home-manager
	  {
            home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users."${username}" = home-manager;
	  }
      ];
    }
