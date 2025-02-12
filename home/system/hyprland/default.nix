{ pkgs, inputs, config, ... }:
{
  imports = [ ./bindings.nix ];

  home.packages = with pkgs; [ swww ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    settings = {
      "$MOD" = "SUPER";

      env = [ "LIBVA_DRIVER_NAME,nvidia" "__GLX_VENDOR_LIBRARY_NAME,nvidia" ];

      monitor = [ "DP-1, 2560x1440, 2560x0, 1" "DP-2, 1920x1080, 0x0, 1" ];

      general = { resize_on_border = true; };

      decoration = {
        rounding = "10";
        blur = {
          passes = "1";
          size = "3";
          new_optimizations = "true";

        };
        shadow = {
          range = "20";
          render_power = "3";
        };
      };

      # animations = {
      #   enabled = true;
      #
      #   bezier = [ "ease,0.4,0.02,0.21,1" ];
      #
      #   animation = [
      #     "windows, 1, 3.5, ease, slide"
      #     "windowsOut, 1, 3.5, ease, slide"
      #     "border, 1, 6, deault"
      #     "fade, 1, 3, ease"
      #     "workspaces, 1, 3.5, ease"
      #   ];
      #
      # };
    };
  };
}
