{ config, pkgs, lib, ... }:
let
  cfg = config.services.cloudflared;
in {
  options.services.cloudflared = {
    enable = lib.mkEnableOption "cloudflared tunnel";
    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the file containing the tunnel token";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.cloudflared = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "syslog.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run --token-file ${cfg.tokenFile}";
        Restart = "always";
        User = "cloudflared";
        Group = "cloudflared";
        DynamicUser = true;
      };
    };
  };
}

