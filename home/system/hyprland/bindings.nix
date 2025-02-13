{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
	  # --------------------------
      "$MOD SHIFT, d, exec, discord"
      "$MOD SHIFT, f, exec, firefox"
      "$MOD SHIFT, r, exec, wofi"
      "$MOD, RETURN, exec, kitty"

      # ------------------------- 
      "$MOD SHIFT, q, killactive"
      "$MOD, f, fullscreen, 1"
      "$MOD, up, movefocus, u"
      "$MOD, down, movefocus, d"
      "$MOD, left, movefocus, l"
      "$MOD, right, movefocus, r"
      "$MOD SHIFT, j, focusmonitor, -1"
    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$MOD, code:1${toString i}, workspace, ${toString ws}"
        "$MOD SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

  };
}
