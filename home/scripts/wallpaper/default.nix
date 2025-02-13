{ pkgs, config, ... }:
let
  themeDir = "${config.var.configDirectory}" + "/themes";

  wallpaper = pkgs.writeShellScriptBin "wallpaper"
    #bash
    ''

            WALLPAPER_DIR="$HOME/Pictures/wallpapers";
            CURRENT_WALL=$(hyprctl hyprpaper listloaded)

            # Get a random wallpaper that is not the current one
            WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

            # Apply the selected wallpaper
            hyprctl hyprpaper reload ,"$WALLPAPER"

      	  echo "$WALLPAPER" > ${themeDir}/style/currentWallpaper.txt


            		'';

in { home.packages = [ wallpaper ]; }
