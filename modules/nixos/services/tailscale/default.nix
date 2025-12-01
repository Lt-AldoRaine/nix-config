{ config, lib, ... }:
let
  cfg = config.services.tailscale;
in
{
  services.tailscale = {
    enable = true;
    # Enable routing features for subnet routing and exit node functionality
    useRoutingFeatures = "both";
  };

  # Trust the Tailscale interface for firewall rules
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ cfg.port ];
  };
}
