{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers.jellyseerr = {
    image = "fallenbagel/jellyseerr:latest";
    autoStart = true;
    
    ports = [
      "5055:5055"
    ];
    
    volumes = [
      "/var/lib/jellyseerr:/app/config"
    ];
    
    environment = {
      TZ = "America/Chicago";
    };
  };

  networking.firewall.allowedTCPPorts = [ 5055 ];
}

