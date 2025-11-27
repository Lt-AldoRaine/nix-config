{
  description = "My Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    stylix.url = "github:danth/stylix";

    hyprland.url = "github:hyprwm/Hyprland";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    let
      inherit (nixpkgs) lib;
      customLib = import ./lib { inherit inputs lib; };
      hostSpecs = import ./hosts { mkHost = customLib.mkHost; };
      nixosModules = import ./modules/nixos {
        collectModules = customLib.collectModules;
      };
      homeManagerModules = import ./modules/home {
        collectModules = customLib.collectModules;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-rfc-style;
      };

      flake = {
        lib = customLib;
        inherit nixosModules homeManagerModules;
        nixosConfigurations =
          customLib.mkNixosConfigurations hostSpecs;
      };
    };
}
