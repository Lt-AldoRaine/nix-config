{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.homelab.hosts.odin;
  hostconfiguration = {
    description = "Odin VPS server on Hetzner Cloud";
    roles = [ "caddy" "prometheus" "grafana" "authelia" "homepage" ];
    dnsalias = [
      "grafana"
      "prometheus"
      "auth"
    ];

    icon = "https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png";
    ipv4 = null; # Set actual IP or use Tailscale
    os = "NixOS";
    nproc = 2;

    parent = null;
    zone = "vps";

    params = {
      # Add any host-specific parameters here
      hetzner = {
        serverType = "cpx11";
        location = "ash"; # Ashburn, Virginia
      };
    };
  };
in
{
  imports = [ ];

  homelab.hosts.odin = hostconfiguration;
}


