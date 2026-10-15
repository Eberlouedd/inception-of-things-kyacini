i#!/usr/bin/env bash
set -Eeuo pipefail

export INSTALL_K3S_EXEC="server \
  --node-ip=192.168.56.110 \
  --advertise-address=192.168.56.110 \
  --write-kubeconfig-mode=644"

curl -sfL https://get.k3s.io | sh -

# Attendre que Kubernetes enregistre son nœud
until kubectl get nodes --no-headers 2>/dev/null | grep -q .; do
  echo "Waiting for Kubernetes node..."
  sleep 3
done

# Attendre que le nœud soit prêt
kubectl wait --for=condition=Ready node --all --timeout=300s

# Déployer les applications
kubectl apply -f /vagrant/confs/apps.yaml
kubectl apply -f /vagrant/confs/ingress.yaml

# Attendre les applications
kubectl wait --for=condition=Available deployment --all --timeout=300s

# Attendre Traefik
echo "Waiting for Traefik..."
until kubectl get deployment traefik -n kube-system >/dev/null 2>&1; do
  sleep 5
done

kubectl rollout status deployment/traefik -n kube-system --timeout=600s

# Configurer kubectl pour vagrant
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
