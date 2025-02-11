{ pkgs, inputs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      "$MOD" = "SUPER";

      bind = [ "$mod, F, exec, firefox" ] ++ (builtins.concatLists
        (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9));
    };

    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    # ];

    systemd.variables = [ "--all" ];
  };
}
