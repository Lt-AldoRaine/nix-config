{ inputs, lib }:
let
  collectModules = dir:
    let
      entries = builtins.readDir dir;
      wanted = lib.filterAttrs
        (name: type:
          type == "directory"
          || (type == "regular" && lib.hasSuffix ".nix" name)
          || (type == "symlink" && lib.hasSuffix ".nix" name))
        entries;
    in
    lib.mapAttrs'
      (name: type:
        if type == "directory" then
          lib.nameValuePair name (import (dir + "/${name}"))
        else
          lib.nameValuePair (lib.removeSuffix ".nix" name) (import (dir + "/${name}")))
      wanted;

  monitoring = import ./monitoring { inherit lib; };

  nixosModules = import ../modules/nixos {
    collectModules = collectModules;
  };

  homeManagerModules = import ../modules/home {
    collectModules = collectModules;
  };

  terranixModules = import ../modules/terranix {
    inherit lib;
  };

  baseModules = [
    {
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
      nixpkgs.config.allowUnfree = true;
      _module.args = {
        inherit inputs;
        self = inputs.self;
      };
      clan.core.settings.directory = lib.mkDefault (builtins.toString inputs.self);
    }
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.age
    inputs.clan-core.nixosModules.clanCore
  ];

  mkHost = { system, modules ? [ ], extraModules ? [ ] }:
    {
      inherit system;
      modules = baseModules ++ modules ++ extraModules;
    };

  mkNixosConfigurations = hosts:
    lib.mapAttrs
      (_name: spec:
        inputs.nixpkgs.lib.nixosSystem {
          inherit (spec) system;
          modules = spec.modules;
          specialArgs = {
            inherit inputs;
            self = inputs.self;
          };
        })
      hosts;

  modules = {
    terranix = terranixModules;
    nixos = nixosModules;
    home = homeManagerModules;
  };
in
{
  inherit
    baseModules
    mkHost
    mkNixosConfigurations
    collectModules
    monitoring
    nixosModules
    homeManagerModules
    modules;
}

