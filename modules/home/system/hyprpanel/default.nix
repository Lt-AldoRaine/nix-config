# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{ inputs, config, pkgs, ... }:
let
  inherit (config.var.theme) rounding border-size gaps-out gaps-in;

  inherit (config.var.theme.bar) floating transparent position;

  inherit (config.var) location configDirectory;

  # Bar/menu accent colors come from wallust at runtime (patched into
  # config.json by wallpaper-cycle), not from Nix - see the wallust module.
  font = "SFProDisplay Nerd Font";
  fontSize = "14";

  defaultWallpaper = "${configDirectory}/themes/style/wallpapers/Tokyo_Pink.png";
in {
  #imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

	home.packages = with pkgs; [
		libgtop
		bluez
		dart-sass
	];

  programs.hyprpanel = {
    enable = true;
    settings = {
    bar = {
      layouts = {
        "0" = {
          "left" =
            [ "dashboard" "workspaces" "cpu" "cputemp" "ram" "windowtitle" ];
          "middle" = [ "media" ];
          "right" = [
            "systray"
            "volume"
            "bluetooth"
            "network"
            "clock"
            "notifications"
          ];
        };
        "1" = {
          "left" = [ ];
          "middle" = [ "clock" ];
          "right" = [ ];
        };
      };
    };

      "theme.font.name" = "${font}";
      "theme.font.size" = "${fontSize}px";
      "theme.bar.outer_spacing" =
        "${if floating && transparent then "0" else "8"}px";
      "theme.bar.buttons.y_margins" =
        "${if floating && transparent then "0" else "8"}px";
      "theme.bar.buttons.spacing" = "0.2em";
      "theme.bar.buttons.radius" = "${
          if transparent then toString rounding else toString (rounding - 8)
        }px";
      "theme.bar.floating" = "${if floating then "true" else "false"}";
      "theme.bar.buttons.padding_x" = "0.8rem";
      "theme.bar.buttons.padding_y" = "0.4rem";
      "theme.bar.margin_top" =
        "${if position == "top" then toString (gaps-in * 2) else "0"}px";
      "theme.bar.margin_bottom" =
        "${if position == "top" then "0" else toString (gaps-in * 2)}px";
      "theme.bar.margin_sides" = "${toString gaps-out}px";
      "theme.bar.border_radius" = "${toString rounding}px";
      "bar.launcher.icon" = "";
      "theme.bar.transparent" = "${if transparent then "true" else "false"}";
			"bar.autoHide" = "fullscreen";
      "bar.workspaces.show_numbered" = false;
      "bar.workspaces.workspaces" = 5;
      "bar.workspaces.hideUnoccupied" = false;
      "bar.windowtitle.label" = true;
      "bar.volume.label" = false;
      "bar.network.truncation_size" = 12;
      "bar.bluetooth.label" = false;
      "bar.clock.format" = "%a %b %d  %I:%M %p";
      "bar.notifications.show_total" = true;
      "theme.notification.border_radius" = "${toString rounding}px";
      "theme.osd.enable" = true;
      "theme.osd.orientation" = "vertical";
      "theme.osd.location" = "left";
      "theme.osd.radius" = "${toString rounding}px";
      "theme.osd.margins" = "0px 0px 0px 10px";
      "theme.osd.muted_zero" = true;
      "menus.clock.weather.location" = "${location}";
      "menus.clock.weather.unit" = "imperial";
      "menus.dashboard.powermenu.confirmation" = false;

      "menus.dashboard.shortcuts.left.shortcut4.command" = "menu";
      "menus.dashboard.shortcuts.left.shortcut4.tooltip" = "Search Apps";
      "menus.dashboard.shortcuts.right.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.right.shortcut1.command" = "hyprpicker -a";
      "menus.dashboard.shortcuts.right.shortcut1.tooltip" = "Color Picker";
      "menus.dashboard.shortcuts.right.shortcut3.icon" = "󰄀";
      "menus.dashboard.shortcuts.right.shortcut3.command" =
        "screenshot region swappy";
      "menus.dashboard.shortcuts.right.shortcut3.tooltip" = "Screenshot";

      "theme.bar.menus.monochrome" = true;
      "wallpaper.enable" = false;
      "wallpaper.image" = defaultWallpaper;
      "theme.matugen" = false;
      "theme.bar.menus.card_radius" = "${toString rounding}px";
      "theme.bar.menus.border.size" = "${toString border-size}px";
      "theme.bar.menus.border.radius" = "${toString rounding}px";
      "theme.bar.buttons.style" = "default";
      "theme.bar.buttons.monochrome" = true;
      "theme.bar.menus.menu.media.card.tint" = 90;
      "bar.customModules.updates.pollingInterval" = 1440000;
      "bar.media.show_active_only" = true;
      "theme.bar.location" = "${position}";
      "bar.workspaces.numbered_active_indicator" = "color";
      "bar.workspaces.monitorSpecific" = false;
      "bar.workspaces.applicationIconEmptyWorkspace" = "";
      "bar.workspaces.showApplicationIcons" = true;
      "bar.workspaces.showWsIcons" = true;
      "theme.bar.dropdownGap" = "4.5em";
    };
  };
}
