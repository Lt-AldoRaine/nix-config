{
  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/media";
    stateDir = "/media/.state/nixarr";

    jellyfin = {
      enable = true;
      # expose.https = {
      #   enable = true;
      #   domainName = "jellyfin.aldoraine.com";
      #   acmeMail = "cpenn@aldoraine.com"; # Required for ACME-bot
      # };
    };
    lidarr.enable = true;
    jellyseerr = {
      enable = true;
      # expose.https = { domainName = "jellyseerr.aldoraine.com"; };
    };
    prowlarr = { enable = true; };
    radarr = { enable = true; };
    sonarr = { enable = true; };
    sabnzbd = { enable = true; };
  };
}
