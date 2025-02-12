{ config, pkgs, lib, ... }: {
  programs.waybar = {
    style = ''
      * {
          border: none;
          border-radius: 0px;
          font-family: "JetBrainsMono"
        ;
            font-weight: bold;
                font-size: 11px;
            min-height: 0;
            transition: 0.3s;
        }

        window#waybar {
            background: rgba(21, 18, 27, 0);
            color: transparent;
        }

        tooltip {
            background: #1e1e2e;
            border-radius: 10px;
            border-width: 1.5px;
            border-style: solid;
            border-color: #11111b;
            transition: 0.3s;
        }

        #workspaces button {
            padding: 5px;
            color: #313244;
            margin-right: 5px;
        }

        #workspaces button.active {
            color: #a6adc8;
        }

        #workspaces button.focused {
            color: #a6adc8;
            background: #eba0ac;
            border-radius: 20px;
        }

        #workspaces button.urgent {
            color: #11111b;
            background: #a6e3a1;
            border-radius: 20px;
        }

        #workspaces button:hover {
            background: #11111b;
            color: #cdd6f4;
            border-radius: 20px;
        }

        #custom-power_profile,
        #custom-weather,
        #window,
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #bluetooth,
        #temperature,
        #workspaces,
        #tray,
        #backlight {
            background: #1e1e2e;
            opacity: 0.8;
            padding: 0px 10px;
            margin: 0;
            margin-top: 5px;
            border: 1px solid #181825;
        }

        #temperature {
            border-radius: 20px 0px 0px 20px;
        }

        #temperature.critical {
            color: #eba0ac;
        }

        #backlight {
            border-radius: 20px 0px 0px 20px;
            padding-left: 7px;
        }

        #tray {
            border-radius: 20px;
            margin-right: 5px;
            padding: 0px 4px;
        }

        #workspaces {
            background: #1e1e2e;
            border-radius: 20px;
            margin-left: 5px;
            padding-right: 0px;
            padding-left: 5px;
        }

        #custom-power_profile {
            color: #a6e3a1;
            border-left: 0px;
            border-right: 0px;
        }

        #window {
            border-radius: 20px;
            margin-left: 5px;
            margin-right: 5px;
        }

        #clock {
            color: #fab387;
            border-radius: 20px;
            margin-left: 5px;
            border-right: 0px;
            transition: 0.3s;
            padding-left: 7px;
        }

        #network {
            color: #f9e2af;
            border-radius: 20px 0px 0px 20px;
            border-left: 0px;
            border-right: 0px;
        }

        #bluetooth {
            color: #89b4fa;
            border-radius: 20px;
            margin-right: 10px
        } 

        #pulseaudio {
            color: #89b4fa;
            border-left: 0px;
            border-right: 0px;
        }

        #pulseaudio.microphone {
            color: #cba6f7;
            border-left: 0px;
            border-right: 0px;
            border-radius: 0px 20px 20px 0px;
            margin-right: 5px;
            padding-right: 8px;
        }

        #battery {
            color: #a6e3a1;
            border-radius: 0 20px 20px 0;
            margin-right: 5px;
            border-left: 0px;
        }

        #custom-weather {
            border-radius: 20px;
            border-right: 0px;
            margin-left: 0px;
        }
    '';
  };
}
