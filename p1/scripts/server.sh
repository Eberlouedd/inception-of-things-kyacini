#!/usr/bin/env bash
set -Eeuo pipefail

export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110 --advertise-address=192.168.56.110 --tls-san=192.168.56.110 --write-kubeconfig-mode=644"

if ! command -v k3s >/dev/null 2>&1; then
  curl -sfL https://get.k3s.io | sh -
fi

systemctl enable --now k3s

for _ in $(seq 1 120); do
  if systemctl is-active --quiet k3s &&
     test -s /var/lib/rancher/k3s/server/node-token &&
     k3s kubectl get --raw=/readyz >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

test -s /var/lib/rancher/k3s/server/node-token || {
  echo "K3s server token missing" >&2
  exit 1
}

k3s kubectl get --raw=/readyz >/dev/null

install -d -m 0755 -o vagrant -g vagrant /home/vagrant/.kube
install -m 0644 -o vagrant -g vagrant \
  /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
