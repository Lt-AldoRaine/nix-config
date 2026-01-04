{ pkgs, ... }:

{
  services.lidarr = {
    enable = true;
    dataDir = "/var/lib/lidarr";
    openFirewall = true;
  };
}


