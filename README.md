# NixOS Configuration

My personal NixOS setup for both my homelab server and desktop workstation. Everything is managed declaratively with Nix Flakes.

## What's in here

This repo contains the complete configuration for:

- **Homelab server**: Self-hosted media services, monitoring, and infrastructure tools
- **Desktop workstation**: Development environment and daily use setup

All the services, system settings, and user configs are defined here and can be rebuilt from scratch.

## Services

The homelab runs a bunch of self-hosted services:

- **Caddy** - Reverse proxy with automatic HTTPS
- **Jellyfin** - Media server for movies and TV
- **Blocky** - DNS filtering and ad-blocking
- **Authelia** - Single sign-on for web services
- **Prometheus & Grafana** - Monitoring and dashboards
- **Glance** - Service dashboard
- **Tailscale** - VPN for remote access
- **Docker** - Container runtime

Plus the usual media automation stack (Sonarr, Radarr, Lidarr, Prowlarr, Jellyseerr, qBittorrent, SABnzbd).

## Hosts

### homelab

The main server that runs all the self-hosted services. Uses Authelia for authentication, Caddy for reverse proxying with Cloudflare DNS challenge, and has monitoring set up with Prometheus and Grafana.

### aldoraine

My desktop workstation. GNOME desktop, Neovim for editing, and the usual development tools.

## Repository Structure

```
.
├── flake.nix              # Flake definition and inputs
├── hosts/                 # Host-specific configurations
│   ├── homelab/          # Homelab server config
│   │   ├── configuration.nix
│   │   ├── secrets.nix   # Agenix secret key definitions
│   │   └── secrets/      # Encrypted secrets (.age files)
│   └── aldoraine/        # Desktop workstation config
├── modules/              # Reusable NixOS modules
│   ├── nixos/           # System-level modules
│   │   ├── services/    # Service configurations
│   │   └── system/      # System configs (users, fonts, etc.)
│   └── home/            # Home Manager modules
├── lib/                  # Helper functions
│   └── monitoring/       # Monitoring helpers and templates
└── themes/               # Styling and theming configs
```

## Secrets

Secrets are managed with [agenix](https://github.com/ryantm/agenix). The `secrets.nix` file defines which SSH keys can decrypt each secret, and the encrypted `.age` files are committed to git.

## Monitoring

I've got Prometheus scraping metrics from all the services, and Grafana for visualization. There's a monitoring helper library in `lib/monitoring/` that makes it easy to add metrics and alerts for new services.

## Credits

Thanks to the NixOS community and all the open source projects that make this possible, especially:

- [NixOS](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [agenix](https://github.com/ryantm/agenix)
