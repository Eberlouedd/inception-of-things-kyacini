# Defense checklist

Replace `jdoe` and the repository URL with your own values before the defense.

## Part 1

```sh
cd p1
IOT_LOGIN=jdoe vagrant up
IOT_LOGIN=jdoe vagrant status
IOT_LOGIN=jdoe vagrant ssh jdoeS -c 'kubectl get nodes -o wide'
```

Show two `Ready` nodes, the `jdoeS`/`jdoeSW` hostnames, IPs
`192.168.56.110`/`192.168.56.111`, and passwordless SSH.

## Part 2

```sh
cd p2
IOT_LOGIN=jdoe vagrant up
curl -H 'Host: app1.com' 192.168.56.110
curl -H 'Host: app2.com' 192.168.56.110
curl 192.168.56.110
IOT_LOGIN=jdoe vagrant ssh jdoeS -c 'kubectl get pods,deploy,svc,ingress -o wide'
```

Show that `app2` has three ready replicas and display the Ingress definition.

## Part 3

```sh
cd p3
sudo ./scripts/install-tools.sh
GIT_REPO=https://github.com/user/inception-of-things-jdoe.git ./scripts/setup.sh
kubectl get ns argocd dev
kubectl get application -n argocd
kubectl get pods -n dev
curl localhost:8888
```

Commit the `v1` to `v2` image change in `p3/confs/app/deployment.yaml`, push it,
force an Argo refresh if needed, and show the synchronized application followed
by the `v2` response.

## Questions to prepare

- K3s is a lightweight Kubernetes distribution; K3d runs K3s nodes as Docker
  containers for fast local clusters.
- A Deployment maintains replica state, a Service gives stable discovery, and
  an Ingress routes HTTP requests into cluster Services.
- Argo CD continuously compares Git's desired state with live cluster state;
  automated sync, pruning, and self-healing implement this GitOps loop.

