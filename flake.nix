{
  description = "My Nix Config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    stylix.url = "github:danth/stylix/";

	# base16.url = "github:SenchoPens/base16";
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    nixos-system = import ./system/nixos.nix {
      inherit inputs; 
      username = "connor";
      password = "cpenn";
    };

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
  in {
      nixosConfigurations = {
	workspace = nixos-system "x86_64-linux";
	modules = [ stylix.nixosModules.stylix ];
	};
      homeConfigurations = {
        "connor@workspace" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; };
          # > Our main home-manager configuration file <
          modules = [ 
	    stylix.homeManagerModules.stylix
	    ./home-manager/home.nix
	  ];
      	};
      };
    };
  }
