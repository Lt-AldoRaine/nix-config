{ config, ... }:
let
  user = import ../../vars/users/homelab.nix;
  themes = import ../../vars/themes.nix;
in
{
  imports = [ ../../modules/nixos/system/variables-config/default.nix ];
  config.var = user // {
    hostname = "odin";
    theme = themes.dracula;
  };
}

