# Agenix Setup Instructions

## Step 1: Get Your SSH Host Public Key

Run this command on your homelab machine:
```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub
```

Copy the output (it should look like `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...`)

## Step 2: Update secrets.nix

Edit `hosts/homelab/secrets.nix` and replace the placeholder `homelabHostKey` with your actual SSH host public key.

## Step 3: Create the Encrypted Secrets

### For Cloudflare API Token:

First, get your Cloudflare API token from the Cloudflare dashboard, then:

```bash
# Create the encrypted file with your Cloudflare token
echo "CLOUDFLARE_DNS_API_TOKEN=your-actual-token-here" | agenix -e hosts/homelab/secrets/cloudflare-api-token.age
```

Replace `your-actual-token-here` with your actual Cloudflare DNS API token.

## Step 4: Verify Secrets

You can verify the secrets were created correctly:

```bash
# View Cloudflare token (should show CLOUDFLARE_DNS_API_TOKEN=...)
agenix -d hosts/homelab/secrets/cloudflare-api-token.age
```

## Step 5: Rebuild

After creating the secrets, rebuild your system:

```bash
sudo nixos-rebuild switch --flake ".#homelab"
```

## Troubleshooting

If you get permission errors:
- Make sure you're using your SSH key that's listed in `secrets.nix`
- The secrets will be decrypted at build time using your SSH key
- Make sure `~/.ssh/id_ed25519` (or your SSH key) is available

If you need to edit a secret later:
```bash
agenix -e hosts/homelab/secrets/cloudflare-api-token.age
```

## Notes

- The `.age` files are encrypted and safe to commit to git
- Never commit unencrypted secrets
- The secrets are decrypted at build time and stored in `/run/agenix/` at runtime
- Only the SSH keys listed in `secrets.nix` can decrypt each secret

