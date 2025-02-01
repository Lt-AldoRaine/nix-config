{
  description = "My Nix Config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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
        };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "connor@workspace" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs;};
          # > Our main home-manager configuration file <
          modules = [./home-manager/home.nix];
      	};
      };
    };
  }
