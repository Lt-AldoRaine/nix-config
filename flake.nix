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
          ./hosts/configuration.nix
        ];
      };
      # homeConfigurations = {
      #   "connor@workspace" = home-manager.lib.homeManagerConfiguration {
      #     pkgs =
      #       nixpkgs.legacyPackages."x86_64-linux"; # Home-manager requires 'pkgs' instance
      #     extraSpecialArgs = { inherit inputs; };
      #     # > Our main home-manager configuration file <
      #     modules = [ stylix.homeManagerModules.stylix ./home-manager/home.nix ];
      #   };
    };
  };
}
