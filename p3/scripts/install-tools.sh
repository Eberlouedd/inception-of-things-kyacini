#!/usr/bin/env bash
set -Eeuo pipefail

if (( EUID != 0 )); then
  echo "Run this installer as root (sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl git docker.io
systemctl enable --now docker

if ! command -v kubectl >/dev/null 2>&1; then
  case "$(dpkg --print-architecture)" in
    amd64) kubectl_arch=amd64 ;;
    arm64) kubectl_arch=arm64 ;;
    *) echo "Unsupported architecture for kubectl" >&2; exit 1 ;;
  esac
  curl -sfL https://dl.k8s.io/release/stable.txt -o /tmp/kubectl-version
  version=$(cat /tmp/kubectl-version)
  curl -sfL "https://dl.k8s.io/release/${version}/bin/linux/${kubectl_arch}/kubectl" -o /usr/local/bin/kubectl
  chmod 0755 /usr/local/bin/kubectl
fi

if ! command -v k3d >/dev/null 2>&1; then
  curl -sfL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

if ! command -v helm >/dev/null 2>&1; then
  curl -sfL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

invoking_user=${SUDO_USER:-$(id -un)}
usermod -aG docker "$invoking_user"
echo "Tools installed. Log out and back in if Docker access was just granted."
