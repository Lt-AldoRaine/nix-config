# awww displays wallpapers; colors come from wallust at runtime.
# The daemon just holds whatever image was last set (via wallust's
# wallpaper-cycle script), so there's nothing else to configure here.
{ config, pkgs, ... }: {
  home.packages = [ pkgs.awww ];

  systemd.user.services.awww-daemon = {
    Unit = { Description = "awww wallpaper daemon"; };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStop = "${pkgs.awww}/bin/awww kill";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ config.wayland.systemd.target ]; };
  };
}
