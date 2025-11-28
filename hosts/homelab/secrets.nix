let
  # System SSH host key
  homelabHostKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV9oKjLJ736HxSOwKuk921qBH7qmEDilGH+FWFHFaOP root@nixos";
  
  # User's homelab key
  homelabUserKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUbHbQvRblFbKll9PxVzwiwW3PZsPYULJdiIsqHItgU connor@homelab";
in {
  # Cloudflare API token for Caddy (format: CLOUDFLARE_DNS_API_TOKEN=token-value)
  "secrets/cloudflare-api-token.age".publicKeys = [ homelabHostKey homelabUserKey ];

  # Authelia JWT secret
  "secrets/authelia-jwt-secret.age".publicKeys = [ homelabHostKey homelabUserKey ];

  # Authelia storage encryption key
  "secrets/authelia-storage-encryption-key.age".publicKeys = [ homelabHostKey homelabUserKey ];

  # CurseForge API key for Minecraft server (format: CF_API_KEY=your-key-here)
  "secrets/curseforge-api-key.age".publicKeys = [ homelabHostKey homelabUserKey ];

}
