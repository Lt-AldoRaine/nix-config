{ inputs, lib }:
let
  baseModules = [
    {
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
      _module.args = { inherit inputs; };
    }
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
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
          specialArgs = { inherit inputs; };
        })
      hosts;

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
in
{
  inherit baseModules mkHost mkNixosConfigurations collectModules;
}

