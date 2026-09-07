#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

required=(
  p1/Vagrantfile p1/scripts/server.sh p1/scripts/worker.sh
  p2/Vagrantfile p2/scripts/server.sh p2/confs/apps.yaml p2/confs/ingress.yaml
  p3/scripts/setup.sh p3/scripts/install-tools.sh p3/confs/argocd-application.yaml
  p3/confs/app/deployment.yaml p3/confs/app/service.yaml
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "missing: $file" >&2; exit 1; }
done

find p1 p2 p3 scripts -type f -name '*.sh' -print0 |
  xargs -0 -n1 bash -n

if command -v kubectl >/dev/null 2>&1; then
  kubectl apply --dry-run=client --validate=false -f p2/confs/apps.yaml >/dev/null
  kubectl apply --dry-run=client --validate=false -f p2/confs/ingress.yaml >/dev/null
  kubectl apply --dry-run=client --validate=false -f p3/confs/app >/dev/null
fi

echo "Static checks passed."

