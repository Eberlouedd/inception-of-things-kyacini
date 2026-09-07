# Inception-of-Things (IoT)

Implementation of the three mandatory parts of the 42 **Inception-of-Things**
project (subject v4.0).

## Prerequisites

- A Linux virtual machine (the whole project must be demonstrated from a VM)
- Vagrant and a supported provider for `p1` and `p2`
- Internet access during first installation
- For `p3`: a public GitHub repository containing this project

The Vagrantfiles default to the VirtualBox provider and the
`bento/ubuntu-24.04` box. Set `VAGRANT_PROVIDER` and/or `VAGRANT_BOX` if your
host uses another supported provider.

## Configuration

Set your 42 login before running Vagrant:

```sh
export IOT_LOGIN=yourlogin
```

For Part 3, also set the public repository URL:

```sh
export GIT_REPO=https://github.com/your-user/inception-of-things-yourlogin.git
export GIT_REVISION=main
```

## Run

```sh
# Part 1 - two-node K3s cluster
cd p1 && vagrant up

# Part 2 - K3s, three apps, host-based ingress
cd p2 && vagrant up

# Part 3 - K3d and Argo CD (run inside your Linux VM)
cd p3 && IOT_LOGIN="$IOT_LOGIN" GIT_REPO="$GIT_REPO" ./scripts/setup.sh
```

Each directory contains its own README with verification and defense commands.

## Repository layout

```text
p1/  K3s server + K3s agent with Vagrant
p2/  K3s server + three applications and Ingress
p3/  K3d + Argo CD GitOps deployment
```

Run static checks with `./scripts/check.sh` from the repository root.

