# Part 2 - K3s and three applications

```sh
export IOT_LOGIN=jdoe
vagrant up
curl -H 'Host: app1.com' 192.168.56.110
curl -H 'Host: app2.com' 192.168.56.110
curl 192.168.56.110
vagrant ssh "${IOT_LOGIN}S" -c 'kubectl get deploy,pods,svc,ingress -o wide'
```

The responses identify `app1`, `app2`, and the default `app3`. The `app2`
deployment has exactly three replicas.

