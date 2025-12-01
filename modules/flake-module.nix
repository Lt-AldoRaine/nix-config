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
    # Terranix modules for terraform configuration
    terranix = {
      base = ./terranix/base.nix;
      hcloud = ./terranix/hcloud.nix;
    };
    # NixOS modules
    nixos = customLib.nixosModules;
    # Home Manager modules
    home = customLib.homeManagerModules;
  };
}
