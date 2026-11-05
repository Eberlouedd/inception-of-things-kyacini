#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"

LOGIN="${IOT_LOGIN:-kyacini}"
SERVER="${LOGIN}S"
WORKER="${LOGIN}SW"

TOKEN_FILE="$PWD/.k3s-token"

cleanup() {
  rm -f "$TOKEN_FILE"
}
trap cleanup EXIT

echo "[1/4] Starting K3s server..."
vagrant up "$SERVER" --provider=libvirt

echo "[2/4] Waiting for server token..."
umask 077

for attempt in $(seq 1 60); do
  if vagrant ssh "$SERVER" -c \
    "sudo test -s /var/lib/rancher/k3s/server/node-token" \
    >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

vagrant ssh "$SERVER" -c \
  "sudo cat /var/lib/rancher/k3s/server/node-token" \
  > "$TOKEN_FILE"

test -s "$TOKEN_FILE" || {
  echo "ERROR: Cannot retrieve K3s token" >&2
  exit 1
}

chmod 600 "$TOKEN_FILE"

echo "[3/4] Starting K3s worker..."
vagrant up "$WORKER" --provider=libvirt

echo "[4/4] Checking cluster..."
vagrant ssh "$SERVER" -c \
  "sudo k3s kubectl get nodes -o wide"

echo "P1 started successfully."
