#!/usr/bin/env bash
set -Eeuo pipefail

for _ in $(seq 1 120); do
  test -s /vagrant/.k3s-token && break
  sleep 2
done
test -s /vagrant/.k3s-token || { echo "K3s server token was not created" >&2; exit 1; }

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN
K3S_TOKEN=$(cat /vagrant/.k3s-token)
export INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111"
curl -sfL https://get.k3s.io | sh -

