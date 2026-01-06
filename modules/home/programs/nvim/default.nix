{ lib, inputs, ... }:
let
  nixvimModule = inputs.nixvim.homeModules.nixvim;
in {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
    nixvimModule
  ];

  programs.nixvim.enable = lib.mkDefault true;
}
