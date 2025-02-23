{
  description = "My Nix Config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    stylix.url = "github:danth/stylix/";
    hyprland.url = "github:hyprwm/Hyprland";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nur.url = "github:nix-community/NUR";

		spicetify-nix = {
			url = "github:Gerg-L/spicetify-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      aldoraine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays =
              [ inputs.hyprpanel.overlay inputs.nur.overlays.default ];
            _module.args = { inherit inputs; };
          }

          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          ./hosts/main-pc/configuration.nix
        ];
      };
      homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays =
              [ inputs.hyprpanel.overlay inputs.nur.overlays.default ];
            _module.args = { inherit inputs; };
          }

          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          ./hosts/home-server/configuration.nix
        ];
      };
    };
  };
}
