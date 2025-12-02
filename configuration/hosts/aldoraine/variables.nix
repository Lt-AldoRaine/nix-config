{ config, ... }:
let
  user = import ../../../vars/users/connor.nix;
  themes = import ../../../vars/themes.nix;
in
{
  imports = [ ../../../modules/nixos/system/variables-config/default.nix ];
  config.var = user // {
    hostname = "aldoraine";
    theme = themes."2025";
  };
}
