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
  nixosModules = import ../modules/nixos {
    collectModules = customLib.collectModules;
  };
  homeManagerModules = import ../modules/home {
    collectModules = customLib.collectModules;
  };
in
{
  flake = {
    lib = customLib;
    inherit nixosModules homeManagerModules;
    nixosConfigurations = customLib.mkNixosConfigurations allSpecs;
  };
}

