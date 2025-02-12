{ pkgs, ... }: {
  imports = [ ./styles.nix ];

  home.packages = with pkgs; [ waybar ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [{
      "layer" = "top";
      "position" = "top";
      "mod" = "dock";
      "exclusive" = true;
      "passthrough" = false;
      "gtk-layer-shell" = true;
      "height" = 30;
      "modules-left" = [ "clock" "hyprland/window" ];
      "modules-center" = [ ];
      "modules-right" = [
        "temperature"
        "custom/power_profile"
        "battery"
        "backlight"
        "pulseaudio"
        "pulseaudio#microphone"
        "tray"
      ];
      "hyprland/window" = { "format" = "{}"; };

      "wlr/workspaces" = {
        "disable-scroll" = true;
        "all-outputs" = true;
        "on-click" = "activate";
        "persistent_workspaces" = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
          "6" = [ ];
          "7" = [ ];
          "8" = [ ];
          "9" = [ ];
          "10" = [ ];
        };
      };

      # //"custom/power_profile" ={
      #     //shows the current power profile and switches to next on click
      # //    "exec" = "asusctl profile -p | sed s:'Active profile is'::";
      # //    "interval" = 30,
      # //    "format" = "󰈐{}"; 
      # //    "on-click" = "asusctl profile -n; pkill -SIGRTMIN+8 waybar";
      # //    "signal" = 8
      # //},
      #
      # //"custom/weather" : {
      #     //shows the current weather and forecast
      #     // "tooltip" : true,
      #     //"format" : "{}";
      #     //"interval" : 30,
      #     //"exec" : "~/.config/waybar/scripts/waybar-wttr.py";
      #     //"return-type" : "json"
      # //},

      "tray" = {
        "icon-size" = 15;
        "spacing" = 10;
      };

      "clock" = {
        "format" = "{: %I:%M %p   %a, %b %e}";
        "tooltip-format" = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };

      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon} {percent}%";
        "format-icons" = [ "󰃞" "󰃟" "󰃠" ];
        "on-scroll-up" = "brightnessctl set 1%+";
        "on-scroll-down" = "brightnessctl set 1%-";
        "min-length" = 6;
      };

      "battery" = {
        "states" = {
          "good" = 95;
          "warning" = 30;
          "critical" = 20;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = " {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-alt" = "{time} {icon}";
        "format-icons" = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      "pulseaudio" = {
        "format" = "{icon} {volume}%";
        "tooltip" = false;
        "format-muted" = " Muted";
        "on-click" = "pamixer -t";
        "on-scroll-up" = "pamixer -i 5";
        "on-scroll-down" = "pamixer -d 5";
        "scroll-step" = 5;
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [ "" "" "" ];
        };
      };

      "pulseaudio#microphone" = {
        "format" = "{format_source}";
        "format-source" = "Mic: {volume}%";
        "format-source-muted" = "Mic: Muted";
        "on-click" = "pamixer --default-source -t";
        "on-scroll-up" = "pamixer --default-source -i 5";
        "on-scroll-down" = "pamixer --default-source -d 5";
        "scroll-step" = 5;
      };

      # "temperature" = {
      #     "thermal-zone" = 1;
      #     "format" = "{temperatureF}°F ";
      #     "critical-threshold" = 80;
      #     "format-critical" = "{temperatureC}°C ";
      # };

      "network" = {
        "interface" = "wlp2*";
        "format-wifi" = "  {signalStrength}%";
        "format-ethernet" = "{ipaddr}/{cidr} ";
        "tooltip-format" = "{essid} - {ifname} via {gwaddr} ";
        "format-linked" = "{ifname} (No IP) ";
        "format-disconnected" = "Disconnected ⚠";
        "format-alt" = "{ifname}:{essid} {ipaddr}/{cidr}";
      };

      "bluetooth" = {
        "format" = " {status}";
        "format-disabled" = "";
        "format-connected" = " {num_connections}";
        "tooltip-format" = "{device_alias}";
        "tooltip-format-connected" = " {device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}";
      };
    }];
  };
}
