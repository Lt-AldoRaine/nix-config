{ inputs, lib, ... }:
let
  customLib = import ../nix { inherit inputs lib; };
  hostSpecs = import ../configuration/hosts { mkHost = customLib.mkHost; };
in
{
  flake = {
    lib = customLib;
    inherit (customLib) nixosModules homeManagerModules;
    nixosConfigurations = customLib.mkNixosConfigurations hostSpecs;
  };
}

