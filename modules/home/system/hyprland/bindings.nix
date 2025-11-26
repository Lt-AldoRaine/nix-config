{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # --------------------------
      "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
      "$mod , D, exec, discord"
      "$mod, B, exec, firefox"
      "$mod, SPACE, exec, wofi"
      "$mod, RETURN, exec, kitty"

      # ------------------------- 
      "$mod, Q, killactive"
      "$mod, F, fullscreen, 1"
      "$mod SHIFT, F, fullscreen"

      # move focus
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"

      # move window
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"

      # resize window
      "$mod ALT, K, resizeactive, 0 -15"
      "$mod ALT, J, resizeactive, 0 15"
      "$mod ALT, H, resizeactive, -15, 0"
      "$mod ALT, L, resizeactive, 15 0"

    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

    bindm = [ "$mod,mouse:272, movewindow" "$mod,R, resizewindow" ];

  };
}
