{ inputs, lib, ... }:
let
  customLib = import ../lib { inherit inputs lib; };
  hostSpecs = import ../hosts { mkHost = customLib.mkHost; };
  machineSpecs = import ../machines { mkHost = customLib.mkHost; };
  allSpecs = hostSpecs // machineSpecs;
in
{
  flake = {
    lib = customLib;
    inherit (customLib) nixosModules homeManagerModules;
    nixosConfigurations = customLib.mkNixosConfigurations allSpecs;
  };
}

