{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
	  # --------------------------
			"$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
      "$mod , D, exec, discord"
      "$mod, B, exec, firefox"
      "$mod, SPACE, exec, menu"
      "$mod, RETURN, exec, kitty"
			"$mod, C, exec, quickmenu"

      # ------------------------- 
      "$mod, q, killactive"
      "$mod, f, fullscreen, 1"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"

    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

		bindm = [
			"$mod,mouse:272, movewindow"
      "$mod,R, resizewindow" 
		];

  };
}
