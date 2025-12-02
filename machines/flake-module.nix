{
  self,
  inputs,
  ...
}:
let
  odin_ipv4 = null; # Set this if you need a specific IP

  # Machine-specific constants can be defined here
  # borgUser = "u444061";
  # borgHost = "${borgUser}.your-storagebox.de";
  # borgPort = "23";

in
{
  # Machines are configured via machines/default.nix and included in
  # flake-parts/nixos-configurations.nix as nixosConfigurations
  # This file is for any machine-specific flake outputs or configurations

  # Example: If you need machine-specific packages or apps, add them here:
  # perSystem = { config, pkgs, ... }: {
  #   packages.odin-specific = pkgs.hello;
  # };
}
