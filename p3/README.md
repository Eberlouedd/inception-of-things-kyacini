# Part 3 - K3d and Argo CD

Run inside the Linux VM used for the defense:

```sh
sudo ./scripts/install-tools.sh
# Log out/in once if Docker permissions changed.
export GIT_REPO=https://github.com/your-user/inception-of-things-yourlogin.git
export GIT_REVISION=main
./scripts/setup.sh
```

Verify both required namespaces, synchronization, and version 1:

```sh
kubectl get namespaces argocd dev
kubectl get applications -n argocd
kubectl get pods -n dev
curl http://localhost:8888/
```

To demonstrate GitOps, edit `confs/app/deployment.yaml` in the public repository,
replace `wil42/playground:v1` with `wil42/playground:v2`, commit, and push. Then:

```sh
kubectl -n argocd get application playground -w
kubectl -n dev rollout status deployment/playground
curl http://localhost:8888/
```

The final response must report `v2`. Argo CD polls Git automatically; if the
evaluation cannot wait for the next poll, request an immediate refresh:

```sh
kubectl -n argocd annotate application playground argocd.argoproj.io/refresh=hard --overwrite
```

