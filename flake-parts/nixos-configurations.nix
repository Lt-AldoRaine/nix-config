{ inputs, lib, ... }:
let
  customLib = import ../lib { inherit inputs lib; };
  hostSpecs = import ../hosts { mkHost = customLib.mkHost; };
  allSpecs = hostSpecs;
in
{
  flake = {
    lib = customLib;
    inherit (customLib) nixosModules homeManagerModules modules;
    nixosConfigurations = customLib.mkNixosConfigurations allSpecs;
  };
}

