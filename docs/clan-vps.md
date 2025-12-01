# VPS Deployment with Clan

This document describes how to deploy NixOS to VPS servers using Terraform for infrastructure provisioning and Clan for OS installation and management.

## Overview

The VPS deployment process follows this workflow:

1. **Terraform** creates the Hetzner Cloud server with a base Linux image
2. **Clan** installs NixOS on the server using the machine configuration
3. **Clan** manages ongoing updates and configuration changes

## Prerequisites

- Hetzner Cloud account with API token
- SSH key for server access (stored as `~/.ssh/homelab` or `~/.ssh/id_ed25519`)
- Secrets encrypted with agenix (hcloud-token, tailscale-auth-key, etc.)

## Deployment Steps

### 1. Create Infrastructure with Terraform

First, create the Hetzner Cloud server:

```bash
# Initialize Terraform (first time only)
nix run .#terraform -- init

# Plan the deployment
nix run .#terraform -- plan

# Apply to create the server
nix run .#terraform -- apply
```

The wrapper now generates `terraform.tf.json` on demand, selects an `AGENIX_IDENTITY`, decrypts secrets, and keeps all Terraform state in `~/terraform/odin`, so no additional scripting is required inside the repo.

Running the plan/apply cycle will:
- Create the Hetzner Cloud server (`odin`)
- Configure networking (IPv4 and IPv6)
- Upload the SSH public key stored in `hosts/homelab/secrets/terraform/odin/ssh-public-key.age`
- Output the server IP addresses

### 2. Install NixOS with Clan

After Terraform creates the server, install NixOS using Clan:

```bash
# Get the server IP from Terraform output
SERVER_IP=$(nix run .#terraform -- output -raw server_ip)
export CLAN_TARGET_HOST="root@$SERVER_IP"

# Install NixOS on the server (must provide --target-host)
nix run .#clan -- machines install odin \
  --update-hardware-config nixos-facter \
  --target-host "$CLAN_TARGET_HOST" \
  --yes
```

**Note**: Exporting `CLAN_TARGET_HOST` makes follow-up commands easier, but you can always pass `--target-host` explicitly. Until facts are populated you still need to provide the address each time.

This will:
- Connect to the server via SSH
- Detect hardware configuration
- Install NixOS using the `machines/odin/configuration.nix` configuration
- Reboot the server into NixOS

### 3. Update Configuration

After installation, use Clan to update the machine configuration:

```bash
# Get the server IP (if you don't have it)
SERVER_IP=$(nix run .#terraform -- output -raw server_ip)

# Update the machine with latest configuration (must provide --target-host)
nix run .#clan -- machines update odin --target-host root@$SERVER_IP
```

**Note**: Facts (or `CLAN_TARGET_HOST`) still need to be provided until Clan has recorded the machine endpoint.

Alternatively, you can enter a shell with `clan` in your PATH:

```bash
# Enter a shell with clan available
nix shell .#clan

# Then run clan commands directly
clan machines install odin --target-host root@$SERVER_IP --yes
clan machines update odin
```

## Machine Configuration

The `odin` VPS machine is defined in:
- **Terraform config**: `machines/odin/terraform-configuration.nix` - Infrastructure (server, networking)
- **NixOS config**: `machines/odin/configuration.nix` - OS configuration and services
- **Clan inventory**: `machines/flake-module.nix` - Clan machine definition

## Available Commands

### Terraform

```bash
# Run any Terraform command
nix run .#terraform -- <command>

# Examples:
nix run .#terraform -- plan
nix run .#terraform -- apply
nix run .#terraform -- destroy
nix run .#terraform -- output
```

### Clan

```bash
# List all machines
nix run .#clan -- machines list

# Install a machine
nix run .#clan -- machines install odin --target-host root@<ip>

# Update a machine
nix run .#clan -- machines update odin

# SSH into a machine
nix run .#clan -- machines ssh odin
```

Or use `nix shell` to get `clan` in your PATH:

```bash
# Enter shell with clan
nix shell .#clan

# Then use clan directly
clan machines list
clan machines install odin --target-host root@<ip>
clan machines update odin
```

## Secrets Management

Secrets for Terraform are stored in:
- `hosts/homelab/secrets/terraform/odin/hcloud-token.age` - Hetzner Cloud API token
- `hosts/homelab/secrets/terraform/odin/tailscale-auth-key.age` - Tailscale auth key
- `hosts/homelab/secrets/terraform/odin/ssh-public-key.age` - SSH key uploaded to Hetzner

These are encrypted with agenix and decrypted automatically by the Terraform wrapper.

To (re)create the SSH public key secret so it matches the private key on your workstation, run:

```bash
agenix -e hosts/homelab/secrets/terraform/odin/ssh-public-key.age
```

Keep the `publicKeys` list in `hosts/homelab/secrets.nix` up to date so both your laptop and the deploying machines can decrypt it.

## Troubleshooting

### Terraform can't find secrets

Ensure:
- `AGENIX_IDENTITY` is set to your SSH key path, or
- `~/.ssh/homelab` or `~/.ssh/id_ed25519` exists
- Secrets are encrypted and stored in the correct location

### Clan can't connect to server

- Verify the server IP from Terraform output
- Ensure your SSH key is authorized on the server
- Check that the server is accessible (firewall rules, etc.)

### Hardware configuration issues

If hardware detection fails, you can manually edit `machines/odin/hardware-configuration.nix` and run:

```bash
nix run inputs.clan-core.packages.$(nix eval --raw --impure --expr 'builtins.currentSystem').clan -- machines update odin
```

## References

- [Clan Documentation](https://docs.clan.lol/)
- [Terranix Documentation](https://terranix.org/)
- [Hetzner Cloud Provider](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs)

