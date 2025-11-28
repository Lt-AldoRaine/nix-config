{ config, pkgs, lib, ... }:
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
in {
  options.services.docker-containers = {
    enable = lib.mkEnableOption "Docker containers management";
    
    minecraft = {
      enable = lib.mkEnableOption "Minecraft server container";
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/minecraft-server";
        description = "Directory for Minecraft server data";
      };
      curseforgeApiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to file containing CurseForge API key (from agenix)";
      };
      ops = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "LtAldoRaine" "AvrgAndy" ];
        description = "List of Minecraft operator usernames";
      };
    };
  };

  config = lib.mkIf config.services.docker-containers.enable {
    # Minecraft server container
    virtualisation.oci-containers.containers.minecraft = lib.mkIf config.services.docker-containers.minecraft.enable {
      image = "itzg/minecraft-server:latest";
      autoStart = true;
      
      ports = [
        "25565:25565"
      ];

      environment = {
        EULA = "TRUE";
        MOD_PLATFORM = "AUTO_CURSEFORGE";
        CF_SLUG = "terrafirmagreg-modern";
        CF_FORCE_INCLUDE_MODS = "1219053";
        MEMORY = "6G";
        ALLOW_FLIGHT = "TRUE";
        CF_OVERRIDES_EXCLUSIONS = "shaderpacks/**";
        DIFFICULTY = "hard";
        USE_AIKAR_FLAGS = "TRUE";
        OPS = lib.concatStringsSep "\n" config.services.docker-containers.minecraft.ops;
      };

      volumes = [
        "${config.services.docker-containers.minecraft.dataDir}:/data"
      ];

      # Pass CF_API_KEY from systemd environment to container via -e flag
      # The systemd service loads it from the file, and we pass it to Docker
      # This avoids Docker's --env-file interpreting $ characters incorrectly
      extraOptions = lib.optionals (config.services.docker-containers.minecraft.curseforgeApiKeyFile != null) [
        "-e" "CF_API_KEY"
      ];
    };

    # Create data directory for Minecraft server
    systemd.tmpfiles.rules = lib.mkIf config.services.docker-containers.minecraft.enable [
      "d ${config.services.docker-containers.minecraft.dataDir} 0755 ${config.var.username} users -"
    ];

    # Pass CF_API_KEY from secret file to container
    # We use a systemd service override to read the file and pass it via -e flag
    # This avoids Docker's --env-file interpreting $ characters incorrectly
    systemd.services."docker-minecraft" = lib.mkIf (config.services.docker-containers.minecraft.enable && config.services.docker-containers.minecraft.curseforgeApiKeyFile != null) {
      serviceConfig = {
        # Load the environment file - systemd will read CF_API_KEY from it
        EnvironmentFile = [ config.services.docker-containers.minecraft.curseforgeApiKeyFile ];
      };
    };

    # Open firewall port for Minecraft
  #   networking.firewall.allowedTCPPorts = lib.mkIf config.services.docker-containers.minecraft.enable [
  #     config.services.docker-containers.minecraft.port
  #   ];
  };
}

