#!/usr/bin/env bash
set -Eeuo pipefail

export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110 --advertise-address=192.168.56.110 --write-kubeconfig-mode=644"
curl -sfL https://get.k3s.io | sh -

until systemctl is-active --quiet k3s; do sleep 2; done
install -m 0600 /var/lib/rancher/k3s/server/node-token /vagrant/.k3s-token

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

