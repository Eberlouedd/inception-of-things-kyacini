#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
CLUSTER_NAME=${CLUSTER_NAME:-kyacini}
GIT_REPO="https://github.com/Eberlouedd/inception-of-things-kyacini.git"
GIT_REVISION=${GIT_REVISION:-main}

for command in docker k3d kubectl; do
  command -v "$command" >/dev/null 2>&1 || {
    echo "Missing $command. Run: sudo $ROOT_DIR/scripts/install-tools.sh" >&2
    exit 1
  }
done

test -n "$GIT_REPO" || {
  echo "GIT_REPO must be the URL of your public GitHub repository." >&2
  exit 1
}

if ! k3d cluster list --no-headers 2>/dev/null | awk '{print $1}' | grep -Fxq "$CLUSTER_NAME"; then
  k3d cluster create "$CLUSTER_NAME" --agents 1 --port '8888:30080@agent:0'
fi

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait -n argocd --for=condition=Available deployment --all --timeout=300s

sed -e "s|__GIT_REPO__|$GIT_REPO|g" \
    -e "s|__GIT_REVISION__|$GIT_REVISION|g" \
    "$ROOT_DIR/confs/argocd-application.yaml" | kubectl apply -f -

echo "Argo CD is installed and the application is registered."
echo "Application: http://localhost:8888/"
echo "Argo UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"

