{ pkgs, ... }:

{
  services.readarr = {
    enable = true;
    dataDir = "/var/lib/readarr";
    openFirewall = true;
  };
}

