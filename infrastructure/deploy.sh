#!/bin/bash
set -e

echo "=== Ghost Blog VPS Deployment on Hetzner Cloud ==="

# Check for required environment variables
if [ -z "$HCLOUD_TOKEN" ]; then
    echo "Error: HCLOUD_TOKEN environment variable is not set."
    echo "Please set it using: export HCLOUD_TOKEN='your_hetzner_api_token'"
    exit 1
fi

if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
    echo "Please set it using: export TAILSCALE_AUTHKEY='your_tailscale_auth_key'"
    exit 1
fi

# Check if hcloud CLI is installed
if ! command -v hcloud &> /dev/null; then
    echo "Error: hcloud CLI is not installed."
    echo "Please install it: https://github.com/hetznercloud/cli"
    exit 1
fi

# Prepare cloud-init configuration
echo "[1/3] Preparing cloud-init configuration..."
sed "s|\${TAILSCALE_AUTHKEY}|$TAILSCALE_AUTHKEY|g" cloud-init.template.yaml > cloud-init.yaml

SERVER_NAME="ghost-blog-$(date +%s)"
SERVER_TYPE="cx22"
IMAGE="ubuntu-24.04"

# Create the server
echo "[2/3] Deploying server $SERVER_NAME on Hetzner Cloud..."
# Note: we are relying on cloud-init to configure the firewall and setup Tailscale SSH
hcloud server create \
    --name "$SERVER_NAME" \
    --type "$SERVER_TYPE" \
    --image "$IMAGE" \
    --user-data-from-file cloud-init.yaml \
    --location fsn1

# Cleanup
rm cloud-init.yaml

echo "[3/3] Deployment initiated successfully!"
echo "------------------------------------------------------"
echo "Server is booting and running the cloud-init script."
echo "This will install Docker, Ghost, UFW, and Tailscale."
echo ""
echo "Security Notice:"
echo "Public SSH access (port 22) is BLOCKED by the firewall."
echo "To access your server via SSH:"
echo "  1. Wait for the server to appear in your Tailscale admin console."
echo "  2. Connect using Tailscale SSH: ssh root@<tailscale-ip>"
echo ""
echo "To access the Ghost blog:"
echo "  Find the public IPv4 address of the newly created server"
echo "  and navigate to http://<public-ip> in your browser."
echo "------------------------------------------------------"
