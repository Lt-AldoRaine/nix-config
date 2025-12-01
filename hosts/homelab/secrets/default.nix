{ config, lib, ... }:
let
  secretsFile = ../../../sops/secrets.yaml;
  hasSecretsFile = builtins.pathExists secretsFile;
in
{
  assertions = [
    {
      assertion = hasSecretsFile;
      message = "Missing encrypted secrets file at sops/secrets.yaml. Copy sops/secrets.example.yaml and encrypt it with `sops --encrypt`.";
    }
  ];

  sops = {
    defaultSopsFile = secretsFile;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };

    secrets."cloudflare-api-token" = {
      key = "cloudflare-api-token";
      format = "binary";
      path = "/run/secrets/cloudflare-api-token";
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };

    secrets."authelia-jwt-secret" = {
      key = "authelia-jwt-secret";
      format = "binary";
      path = "/run/secrets/authelia-jwt-secret";
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    secrets."authelia-storage-encryption-key" = {
      key = "authelia-storage-encryption-key";
      format = "binary";
      path = "/run/secrets/authelia-storage-encryption-key";
      owner = "authelia-main";
      group = "authelia-main";
      mode = "0400";
    };

    secrets."curseforge-api-key" = {
      key = "curseforge-api-key";
      format = "binary";
      path = "/run/secrets/curseforge-api-key";
      owner = "root";
      group = "root";
      mode = "0400";
    };

    secrets."tailscale-auth-key" = {
      key = "tailscale-auth-key";
      format = "binary";
      path = "/run/secrets/tailscale-auth-key";
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };
}

