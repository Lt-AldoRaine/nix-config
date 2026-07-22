{ config, pkgs, lib, ... }:
let
  wallpaperDir = "${config.var.configDirectory}/themes/style/wallpapers";
  defaultWallpaper = "${wallpaperDir}/Lady.png";

  hyprlandTemplate = ./templates/hyprland-colors.lua;
  kittyTemplate = ./templates/kitty-colors.conf;
  gtkTemplate = ./templates/gtk-colors.css;

  wallustConfig = pkgs.writeText "wallust.toml" ''
    backend = "resized"
    color_space = "lch"
    palette = "dark"

    [hooks]
    hyprland-reload = "hyprctl reload"
    kitty-reload = "killall -SIGUSR1 kitty 2>/dev/null || true"

    [templates]
    hyprland.template = "hyprland-colors.lua"
    hyprland.target = "~/.config/hypr/colors.lua"

    kitty.template = "kitty-colors.conf"
    kitty.target = "~/.config/kitty/colors.conf"

    gtk3.template = "gtk-colors.css"
    gtk3.target = "~/.config/gtk-3.0/colors.css"

    gtk4.template = "gtk-colors.css"
    gtk4.target = "~/.config/gtk-4.0/colors.css"
  '';

  wallpaperCycle = pkgs.writeShellScriptBin "wallpaper-cycle" (
    lib.replaceStrings [
      "@WALLPAPER_DIR@"
      "@DEFAULT_WALLPAPER@"
    ] [
      wallpaperDir
      defaultWallpaper
    ] (builtins.readFile ./scripts/wallpaper-cycle.sh)
  );
in {
  home.packages = with pkgs; [
    wallust
    jq
    wallpaperCycle
  ];

  xdg.configFile = {
    "wallust/wallust.toml".source = wallustConfig;
    "wallust/templates/hyprland-colors.lua".source = hyprlandTemplate;
    "wallust/templates/kitty-colors.conf".source = kittyTemplate;
    "wallust/templates/gtk-colors.css".source = gtkTemplate;
  };

  systemd.user.services.wallust-init = {
    Unit = {
      Description = "Apply wallust colorscheme on login";
      After = [ "awww-daemon.service" ];
      Wants = [ "awww-daemon.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${wallpaperCycle}/bin/wallpaper-cycle --init";
    };
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
