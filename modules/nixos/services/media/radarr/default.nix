{ pkgs, ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/var/lib/radarr";
    openFirewall = true;
  };
}
