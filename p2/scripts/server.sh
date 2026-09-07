#!/usr/bin/env bash
set -Eeuo pipefail

export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110 --advertise-address=192.168.56.110 --write-kubeconfig-mode=644"
curl -sfL https://get.k3s.io | sh -
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done

kubectl apply -f /vagrant/confs/apps.yaml
kubectl apply -f /vagrant/confs/ingress.yaml
kubectl wait --for=condition=Available deployment --all --timeout=180s

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

