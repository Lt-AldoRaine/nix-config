{ pkgs, config, ... }:
let
  nixConfig = config.var.configDirectory;
  theme = pkgs.writeShellScriptBin "change-theme" ''
                #bash

                if [ -z "$1" ]; then
                  echo "Please provide the new wallpaper and theme variables paths."
                  exit 1
                fi

                config="${nixConfig}/hosts/configuration.nix"
                variables="${nixConfig}/hosts/variables.nix"

    						new_theme="$1"

                sed -i "s|/style/|/style/$new_theme|" "$config"
                sed -i "s|/var/|/var/$new_theme|" "$variables"

                echo "Wallpaper path updated to: $new_theme"
                 		'';

in { home.packages = [ theme ]; }
