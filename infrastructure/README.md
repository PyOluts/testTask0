# Infrastructure Task: Ghost Blog Deployment

This folder contains a one-click deployment script to provision a Ghost Blog on a Hetzner VPS with no public SSH access, satisfying the infrastructure task requirement.

## Architecture

* **Provider:** Hetzner Cloud
* **OS:** Ubuntu 24.04
* **Security:** 
  * Public SSH access (port 22) is completely blocked via `ufw` firewall.
  * Access to the server is only available via [Tailscale SSH](https://tailscale.com/tailscale-ssh/), acting as a secure VPN tunnel.
* **Workload:** Docker + Docker Compose running the official Ghost Blog image.
* **Automation:** Fully automated using `hcloud` CLI and `cloud-init`.

## Prerequisites

1. **Hetzner Cloud Account:** You need an API token.
2. **Tailscale Account:** You need an Auth Key to authenticate the server to your Tailscale network.
3. **hcloud CLI:** Install from [Hetzner's GitHub](https://github.com/hetznercloud/cli) or via Homebrew/Apt.

## Usage (One-Click Deploy)

1. Set your credentials as environment variables:
   ```bash
   export HCLOUD_TOKEN='your_hetzner_api_token'
   export TAILSCALE_AUTHKEY='your_tailscale_auth_key'
   ```

2. Run the deployment script:
   ```bash
   cd infrastructure
   bash deploy.sh
   ```

The script will instantly create the server. Behind the scenes, Hetzner will run the `cloud-init` instructions, which update the system, configure the firewall, install Tailscale and Docker, and finally spin up Ghost Blog.

## Accessing the Server

* **To access the Blog UI:** Open `http://<hetzner-public-ip>` in your browser.
* **To access SSH:** Since public SSH is blocked, wait for the machine to appear in your [Tailscale Admin Console](https://login.tailscale.com/admin/machines). Copy its Tailscale IP (e.g. `100.x.y.z`) and run `ssh root@100.x.y.z`.
