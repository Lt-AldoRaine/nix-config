{
  self,
  inputs,
  lib,
  ...
}:
let
  customLib = import ../lib { inherit inputs lib; };
in
{
  #############################################################################
  # Module exports at flake level (like badele's approach)
  #############################################################################
  flake.modules = {
    # NixOS modules
    nixos = customLib.nixosModules;
    # Home Manager modules
    home = customLib.homeManagerModules;
  };
}
