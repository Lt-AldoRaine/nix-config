# Secrets Setup with agenix

This directory contains encrypted secrets managed by agenix.

## Initial Setup

1. **Get your SSH host public key:**
   ```bash
   sudo cat /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. **Update `secrets.nix`** with your actual host key (replace the placeholder)

3. **Create the encrypted secret files:**

   For Cloudflare API token:
   ```bash
   # Read your Cloudflare API token and encrypt it
   echo "CLOUDFLARE_DNS_API_TOKEN=your-token-here" | agenix -e hosts/homelab/secrets/cloudflare-api-token.age

   For Authelia, you'll need to create user accounts in the users database file at /var/lib/authelia/users_database.yml
   ```

## Managing Secrets

- **Edit a secret:**
  ```bash
  ```

- **View a secret:**
  ```bash
  ```

- **Re-encrypt secrets after adding/removing keys:**
  ```bash
  agenix --rekey
  ```

## Notes

- The `secrets.nix` file defines which SSH keys can decrypt each secret
- Both the host SSH key and your user SSH key should be able to decrypt secrets
- Never commit unencrypted secrets to git
- The `.age` files are encrypted and safe to commit

