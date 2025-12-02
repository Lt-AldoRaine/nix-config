{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.homelab.hosts.homelab;
  hostconfiguration = {
    description = "Main homelab server";
    roles = [ "docker" "jellyfin" "caddy" "prometheus" "grafana" "blocky" "authelia" ];
    dnsalias = [
      "jellyfin"
      "home"
      "grafana"
      "prometheus"
    ];

    icon = "https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png";
    ipv4 = "192.168.2.2";
    os = "NixOS";
    nproc = 8;

    parent = null;
    zone = "homelab";

    params = {
      # Add any host-specific parameters here
    };
  };
in
{
  imports = [ ];

  homelab.hosts.homelab = hostconfiguration;
}

