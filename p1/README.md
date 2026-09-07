# Part 1 - K3s and Vagrant

Creates `LOGIN_S` at `192.168.56.110` as a K3s server and `LOGIN_SW` at
`192.168.56.111` as a K3s agent. Actual hostnames omit the underscore and use
the value of `IOT_LOGIN`, for example `jdoeS` and `jdoeSW`.

```sh
export IOT_LOGIN=jdoe
vagrant up
vagrant ssh "${IOT_LOGIN}S" -c 'kubectl get nodes -o wide'
```

Both nodes must be `Ready` and show their dedicated IP addresses. Clean up with
`vagrant destroy -f`.

