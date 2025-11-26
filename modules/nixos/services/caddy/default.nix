{ config, lib, pkgs, ... }:
let
  cfg = config.services.caddy;
in {
  options.services.caddy = {
    enable = lib.mkEnableOption "Caddy web server";
    email = lib.mkOption {
      type = lib.types.str;
      default = "harambefallon@gmail.com";
      description = "Email for ACME registration";
    };
    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          extraConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Extra configuration for the virtual host";
          };
        };
      });
      default = { };
      description = "Virtual hosts configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = cfg.email;
      virtualHosts = cfg.virtualHosts;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 443 ];
  };
}

