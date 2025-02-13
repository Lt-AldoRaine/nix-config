{ pkgs, config, ... }:
let
  wallpaper = pkgs.writeShellScriptBin "wallpaper"
    #bash
    ''

            WALLPAPER_DIR="${config.var.configDirectory}/themes/style/wallpapers";
            CURRENT_WALL=$(hyprctl hyprpaper listloaded)

            # Get a random wallpaper that is not the current one
            WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

            # Apply the selected wallpaper
            hyprctl hyprpaper reload ,"$WALLPAPER"


            		'';

in { home.packages = [ wallpaper ]; }
