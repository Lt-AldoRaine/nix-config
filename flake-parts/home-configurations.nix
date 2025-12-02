{ inputs, lib, ... }:
let
  customLib = import ../lib { inherit inputs lib; };
  hostSpecs = import ../hosts { mkHost = customLib.mkHost; };
  allSpecs = hostSpecs;

  hostsDir = ../configuration/hosts;
  homePathFor = hostName:
    let
      hostPath = hostsDir + "/${hostName}/home.nix";
    in
    if builtins.pathExists hostPath then hostPath else
    null;

  hostHomes =
    lib.filterAttrs
      (hostName: _:
        homePathFor hostName != null)
      allSpecs;

  mkHomeConfiguration = hostName:
    let
      system = (allSpecs.${hostName}).system;
      homeModule = homePathFor hostName;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        homeModule
      ];
      extraSpecialArgs = {
        inherit inputs;
        self = inputs.self;
      };
    };

  homeConfigs =
    lib.mapAttrs
      (hostName: _: mkHomeConfiguration hostName)
      hostHomes;
in
{
  flake.homeConfigurations = homeConfigs;
}

