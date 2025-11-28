{ inputs, lib, ... }:
let
  customLib = import ../lib { inherit inputs lib; };
  hostSpecs = import ../hosts { mkHost = customLib.mkHost; };
  machineSpecs =
    if builtins.pathExists ../machines then
      import ../machines { mkHost = customLib.mkHost; }
    else
      { };
  allSpecs = hostSpecs // machineSpecs;

  hostsDir = ../hosts;
  machinesDir =
    if builtins.pathExists ../machines then ../machines else null;

  homePathFor = hostName:
    let
      hostPath = hostsDir + "/${hostName}/home.nix";
      machinePath =
        if machinesDir == null then null else machinesDir + "/${hostName}/home.nix";
    in
    if builtins.pathExists hostPath then hostPath else
    if machinePath != null && builtins.pathExists machinePath then machinePath else
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

