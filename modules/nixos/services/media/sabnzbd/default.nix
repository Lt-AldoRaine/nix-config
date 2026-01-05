{ pkgs, ... }:

{
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
  };
}
