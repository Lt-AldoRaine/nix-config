# Terranix modules - these are paths to module files
# Used by lib/default.nix for backward compatibility
# Primary access is via flake.modules.terranix from modules/flake-module.nix
{ lib, ... }:
{
  base = ./base.nix;
  hcloud = ./hcloud.nix;
}
