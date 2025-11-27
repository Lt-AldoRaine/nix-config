# NixOS Configuration

My NixOS and Home Manager configuration managed with flakes. This repo contains the configs for my homelab server and personal desktop.

## Hosts

- **homelab** - Main server running various self-hosted services
- **aldoraine** - Personal desktop/workstation

## Services

### Homelab

The homelab runs a bunch of services for media, monitoring, and infrastructure:

- **Caddy** - Reverse proxy with automatic HTTPS via Cloudflare DNS challenge
- **Jellyfin** - Media server for movies, TV shows, and music
- **Blocky** - DNS proxy with ad-blocking and multiple blocklists
- **Authelia** - Authentication and authorization server with 2FA and SSO
- **Prometheus** - Metrics collection and monitoring
- **Grafana** - Dashboards and visualization for Prometheus metrics
- **Homepage** - Simple dashboard for accessing all services
- **Glance** - Another dashboard/startpage
- **Tailscale** - Mesh VPN for secure access
- **Docker** - Container runtime for various services

### Monitoring

I've set up a monitoring stack with Prometheus and Grafana. Each service can easily add its own metrics and alerts using the monitoring helpers in `lib/monitoring/`. The setup includes:

- Prometheus scraping configs for all services
- Alertmanager for alert routing
- Pre-configured dashboards (currently Blocky)
- Reusable monitoring template for adding new services

## Structure

```
.
├── flake.nix              # Flake definition
├── hosts/                 # Host-specific configs
│   ├── homelab/          # Homelab server config
│   └── aldoraine/        # Desktop config
├── modules/              # Reusable NixOS modules
│   ├── nixos/           # System-level modules
│   │   ├── services/    # Service configurations
│   │   └── system/      # System configs (users, fonts, etc.)
│   └── home/            # Home Manager modules
├── lib/                  # Helper functions
│   └── monitoring/       # Monitoring helpers and templates
└── themes/               # Styling/theming configs
```

## Secrets Management

Secrets are managed with [agenix](https://github.com/ryantm/agenix), which encrypts secrets using SSH keys. See `hosts/homelab/AGENIX_SETUP.md` for setup instructions.

Currently encrypted secrets:
- Cloudflare API token (for Caddy DNS challenge)

## Usage

### Building

Build a specific host:
```bash
sudo nixos-rebuild switch --flake ".#homelab"
```

### Adding a new service

1. Create a module in `modules/nixos/services/your-service/`
2. Import it in the host's `configuration.nix`
3. Enable it with `services.your-service.enable = true;`

If you want monitoring, check out `lib/monitoring/template.nix` for an example of adding Prometheus scraping and alerts.

### Adding monitoring to a service

See `lib/monitoring/README.md` for details, but basically:

```nix
let
  monitoring = import ../../../../lib/monitoring { inherit lib; };
  serviceName = "your-service";
  metricsPort = 8080;
in {
  services.prometheus.scrapeConfigs = lib.mkMerge [
    [(monitoring.mkPrometheusScrape { jobName = serviceName; port = metricsPort; })]
  ];
}
```

## Notes

- The homelab uses Caddy for reverse proxying with wildcard SSL certs via Cloudflare
- Blocky is configured as the local DNS server with aggressive ad-blocking
- All services are exposed via `*.aldoraine.com` subdomains
- Monitoring is set up so each service can define its own scrape configs and alerts
