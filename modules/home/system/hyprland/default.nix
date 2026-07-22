{ pkgs, inputs, config, lib, ... }:
let
  hlLib = import ./lib.nix { inherit lib; };

  inherit (config.var.theme)
    border-size gaps-in gaps-out active-opacity inactive-opacity rounding blur;

  inherit (config.var) keyboardLayout;

  envEntries = import ./env.nix { inherit lib; };
  animData = import ./animations.nix { inherit config lib; };
  bindEntries = import ./bindings.nix { inherit pkgs lib; };

  monitors = [
    {
      output = "DP-1";
      mode = "2560x1440@170";
      position = "1920x0";
      scale = 1;
    }
    {
      output = "DP-2";
      mode = "1920x1080@144";
      position = "0x0";
      scale = 1;
    }
  ];

  autostartCmds = [
    "hyprctl setcursor Bibata-ModernClassic 22"
    "hyprpanel"
    "solaar -w 'hide'"
  ];
in {
  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
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

    configType = "lua";

    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    settings = {
      env = envEntries;
      curve = animData.curves;
      animation = animData.animations;
      monitor = monitors;
      bind = bindEntries;

      config = {
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

          blur = { enabled = blur; };
        };

        animations = { enabled = true; };

        input = {
          kb_layout = keyboardLayout;

          kb_options = "caps:escape";
          follow_mouse = 1;
          sensitivity = 0.5;
          repeat_delay = 300;
          repeat_rate = 50;
          numlock_by_default = true;
        };

        cursor = {
          no_hardware_cursors = 1;
          default_monitor = "DP-1";
        };
      };

      window_rule = {
        name = "modal-tag";
        match = { tag = "modal"; };
        float = true;
        pin = true;
        center = true;
      };

      layer_rule = [
        {
          match = { namespace = "launcher"; };
          no_anim = true;
        }
        {
          match = { namespace = "^ags-.*"; };
          no_anim = true;
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (hlLib.luaFn (map (c: "hl.exec_cmd(${hlLib.luaStrLit c})") autostartCmds))
        ];
      };
    };
  };

  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];
}
