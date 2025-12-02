{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.homelab.hosts.aldoraine;
  hostconfiguration = {
    description = "Personal desktop workstation";
    roles = [ "desktop" "development" ];
    dnsalias = [ ];

    icon = "https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png";
    ipv4 = "192.168.2.31"; # Update with actual IP
    os = "NixOS";
    nproc = 12;

    autologin = {
      user = "connor";
      session = "hyprland";
    };

    parent = null;
    zone = "homeoffice";

    params = {
      # Add any host-specific parameters here
    };
  };
in
{
  imports = [ ];

  homelab.hosts.aldoraine = hostconfiguration;
}

