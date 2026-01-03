{ pkgs, ... }:

{
  services.prowlarr = {
    enable = true;
    dataDir = "/var/lib/prowlarr";
    openFirewall = true;
  };
}

