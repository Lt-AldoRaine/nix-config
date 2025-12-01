{ config, lib, ... }:
let
  secretsFile = ../../../sops/secrets.yaml;
  hasSecretsFile = builtins.pathExists secretsFile;
in {
  assertions = [{
    assertion = hasSecretsFile;
    message =
      "Missing encrypted secrets file at sops/secrets.yaml. Copy sops/secrets.example.yaml and encrypt it with `sops --encrypt`.";
  }];

  sops = {
    defaultSopsFile = secretsFile;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };

    secrets = {

      "cloudflare-api-token" = {
        key = "cloudflare-api-token";
        path = "/run/cloudflare-api-token";
        owner = "caddy";
        group = "caddy";
        mode = "0400";
      };

      "authelia-jwt-secret" = {
        key = "authelia-jwt-secret";
        path = "/run/authelia-jwt-secret";
        owner = "authelia-main";
        group = "authelia-main";
        mode = "0400";
      };

      "authelia-storage-encryption-key" = {
        key = "authelia-storage-encryption-key";
        path = "/run/authelia-storage-encryption-key";
        owner = "authelia-main";
        group = "authelia-main";
        mode = "0400";
      };

      "curseforge-api-key" = {
        key = "curseforge-api-key";
        path = "/run/curseforge-api-key";
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "tailscale-auth-key" = {
        key = "tailscale-auth-key";
        path = "/run/secrets/tailscale-auth-key";
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "connor-password-hash" = {
        key = "connor-password";
        path = "/run/secrets/connor-password";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

  };
}
