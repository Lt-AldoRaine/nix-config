{ pkgs, inputs, config, ... }:
let

  inherit (config.var.theme)
    border-size gaps-in gaps-out active-opacity inactive-opacity rounding blur;

  inherit (config.var) keyboardLayout;

in {
  imports = [ ./bindings.nix ./animations.nix ./env.nix ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    settings = {
      "$mod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "AQM_DRM_DEVICES, /dev/dri/gpu1"
      ];

      exec-once = [
        "hyprctl setcursor Bibata-ModernClassic 22"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprpanel"
        "solaar -w 'hide'"
      ];

      monitor =
        [ "DP-1, 2560x1440@170, 1920x0, 1" "DP-2, 1920x1080@144, 0x0, 1" ];

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "DP-1";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        # border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = { enabled = if blur then "true" else "false"; };
      };

      windowrulev2 =
        [ "float, tag:modal" "pin, tag:modal" "center, tag:modal" ];

      layerrule = [ "noanim, launcher" "noanim, ^ags-.*" ];

      input = {
        kb_layout = keyboardLayout;

        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;
      };
    };
  };

  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];
}
