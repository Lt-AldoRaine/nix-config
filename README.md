<div align="center">
    <h1>
        <img src="https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png" width="64" height="64"/>
    </h1>
    <h3 align="center"><strong>Immutable NixOS configuration for homelab and desktop</strong></h3>
    <p>
        My personal infrastructure, fully managed with
        <a href="https://nixos.org">NixOS</a> and <a href="https://nixos.wiki/wiki/Flakes">Nix Flakes</a>. This repository contains
        all configurations for my homelab server, personal desktop, and VPS deployments.
    </p>
</div>

---

## What is this?

This is a complete NixOS configuration that manages:

- **Homelab Server**: Self-hosted services for media, monitoring, and infrastructure
- **Desktop Workstation**: Personal development and productivity setup
- **VPS Deployments**: Remote servers managed via Terraform and Terranix

Everything is declarative, reproducible, and version-controlled.

### Why NixOS?

I'm using NixOS for infrastructure management because:

> Reproducible, declarative, and reliable system configuration

### 📦 Services & Applications

All available homelab services:

<table align="center">
  <tr>
    <td align="center" width="16%">
      <a href="https://caddyserver.com" title="Fast, multi-platform web server with automatic HTTPS">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/caddy.png" width="48" height="48" alt="Caddy"/>
        <br/>Caddy
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://jellyfin.org" title="The Free Software Media System">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/jellyfin.png" width="48" height="48" alt="Jellyfin"/>
        <br/>Jellyfin
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/0xERR0R/blocky" title="Fast and lightweight DNS proxy as ad-blocker for local network">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/blocky.png" width="48" height="48" alt="Blocky"/>
        <br/>Blocky
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://www.authelia.com" title="The Single Sign-On Multi-Factor portal for web apps">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/authelia.png" width="48" height="48" alt="Authelia"/>
        <br/>Authelia
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://prometheus.io" title="Monitoring system and time series database">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/prometheus.png" width="48" height="48" alt="Prometheus"/>
        <br/>Prometheus
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://grafana.com" title="Analytics and monitoring platform">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/grafana.png" width="48" height="48" alt="Grafana"/>
        <br/>Grafana
      </a>
    </td>
  </tr>
  <tr>
    <td align="center" width="16%">
      <a href="https://github.com/glance-app/glance" title="Self-hosted dashboard">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/glance.png" width="48" height="48" alt="Glance"/>
        <br/>Glance
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://tailscale.com" title="Mesh VPN for secure access">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale.png" width="48" height="48" alt="Tailscale"/>
        <br/>Tailscale
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://www.docker.com" title="Container runtime platform">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png" width="48" height="48" alt="Docker"/>
        <br/>Docker
      </a>
    </td>
    <td align="center" width="16%">
      <a href="https://gethomepage.dev" title="Modern homepage">
        <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/homepage.png" width="48" height="48" alt="Homepage"/>
        <br/>Homepage
      </a>
    </td>
  </tr>
</table>

### 🖥️ Hosts & Machines

#### 🏠 [homelab](./hosts/homelab/)

Main server running self-hosted services for media, monitoring, and infrastructure.

**Services:**
- **🔐 Authentication**: Authelia for SSO across all services
- **📊 Monitoring Stack**: Prometheus, Grafana with custom dashboards and alerts
- **🌐 Reverse Proxy**: Caddy with automatic HTTPS via Cloudflare DNS challenge
- **📱 Media Server**: Jellyfin for movies, TV shows, and music
- **🛡️ DNS Filtering**: Blocky with ad-blocking and multiple blocklists
- **📊 Dashboards**: Homepage and Glance for service management
- **🔒 VPN**: Tailscale for secure remote access

#### 💻 [aldoraine](./hosts/aldoraine/)

Personal desktop workstation for daily development and productivity.

**Setup:**
- **🖥️ Desktop Environment**: Hyprland window manager with custom theming
- **🛠️ Development Tools**: Neovim, Git, and full development environment
- **🎨 System Management**: Custom utilities and system configurations

#### ☁️ [odin](./machines/odin/)

Remote VPS on Hetzner Cloud for public-facing services and monitoring.

**Services:**
- **🔐 Authentication**: Authelia for SSO
- **📊 Monitoring Stack**: Prometheus and Grafana
- **🌐 Reverse Proxy**: Caddy with Cloudflare DNS
- **📊 Dashboard**: Homepage for service overview
- **🔒 VPN**: Tailscale for secure access

**Deployment:**
- Infrastructure managed via [Terranix](https://terranix.org/) for declarative Terraform configuration
- OS installation and updates managed via [Clan](https://clan.lol/) framework
- See [VPS Deployment Guide](./docs/clan-vps.md) for detailed instructions

### 🔐 Secrets Management

Secrets are managed with [agenix](https://github.com/ryantm/agenix), which encrypts secrets using SSH keys. The `secrets.nix` file defines which SSH keys can decrypt each secret, and the encrypted `.age` files are safe to commit to git.

### ☁️ Infrastructure as Code

Infrastructure provisioning is handled declaratively using [Terranix](https://terranix.org/), which generates Terraform configurations from Nix expressions. This provides:

- **Pure Nix**: All Terraform configs written in Nix, no HCL
- **Type Safety**: Nix's type system catches errors early
- **Reusability**: Shared modules for common patterns
- **Integration**: Seamless integration with the rest of the NixOS config

### 📊 Monitoring

I've set up a monitoring stack with Prometheus and Grafana. Each service can easily add its own metrics and alerts using the monitoring helpers in `lib/monitoring/`. The setup includes:

- Prometheus scraping configs for all services
- Pre-configured dashboards (currently Blocky)
- Reusable monitoring template for adding new services
- Alerting rules for service health

### ❤️ Thanks

A big thank you to the contributors of OpenSource projects, in particular:

- [NixOS](https://nixos.org/) - The purely functional Linux distribution
- [Home Manager](https://github.com/nix-community/home-manager) - Manage a user environment using Nix
- [agenix](https://github.com/ryantm/agenix) - Secret management for NixOS using age
- [Terranix](https://terranix.org/) - Terraform configuration in Nix
- [Clan](https://clan.lol/) - Infrastructure management framework for NixOS
- [badele/nix-homelab](https://github.com/badele/nix-homelab) - Inspiration for this configuration structure (and bar for bar readme)
- All the service maintainers and the NixOS community
