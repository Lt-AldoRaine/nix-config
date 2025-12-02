{ config, ... }:
let
  nets = config.homelab.networks;
  hl = config.homelab;
in
{
  imports = [
    # Import host-information from each host
    ./homelab/host-information.nix
    ./aldoraine/host-information.nix
    ../../machines/odin/host-information.nix
  ];

  homelab = {
    networkId = 2;
    networks = {
      lan = {
        vlanId = 2;
        net = "192.168.${toString nets.lan.vlanId}.2";
        mask = 24;
      };
      tailscale = {
        net = "100.84.95.66";
        mask = 10;
      };
    };
  };
}

