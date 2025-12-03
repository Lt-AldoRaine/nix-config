{ config, lib, ... }:
{
  sops.secrets = {
    "cloudflare-api-token" = {
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };

    "authelia-jwt-secret" = {
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    "authelia-storage-encryption-key" = {
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    "curseforge-api-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    "tailscale-auth-key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    "connor-password-hash" = {
      neededForUsers = true;
    };

    "root-password-hash" = {
      neededForUsers = true;
    };
  };
}
