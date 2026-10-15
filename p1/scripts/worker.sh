#!/usr/bin/env bash
set -Eeuo pipefail

TOKEN_FILE="/etc/rancher/k3s/cluster-token"

test -s "$TOKEN_FILE" || {
  echo "Missing K3s token: $TOKEN_FILE" >&2
  exit 1
}

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN_FILE="$TOKEN_FILE"
export INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111"

if ! systemctl list-unit-files k3s-agent.service --no-legend 2>/dev/null | grep -q '^k3s-agent.service'; then
  curl -sfL https://get.k3s.io | sh -
fi

systemctl enable --now k3s-agent
