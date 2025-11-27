let
  homelabHostKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV9oKjLJ736HxSOwKuk921qBH7qmEDilGH+FWFHFaOP root@nixos";

  # User SSH public key (from users config)
  userKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC";
in {
  # Authentik secret key (just the secret key value, not a file)
  "secrets/authentik-secret-key.age".publicKeys = [ homelabHostKey userKey ];

  # Cloudflare API token for Caddy (format: CLOUDFLARE_DNS_API_TOKEN=token-value)
  "secrets/cloudflare-api-token.age".publicKeys = [ homelabHostKey userKey ];
}
