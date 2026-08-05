
## Create a new Policy

Create a new policy, called `require-requests` in the `default` namespace.

It must require for all Pods that both `cpu` and `memory` requests are set.

Feel free to explore the [docs](https://kyverno.io/docs) to search for existing examples.

## Test if your Policy works

This should not work:

```
k run nginx --image=nginx
```{{exec}}

This should work:
```
cat <<EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata: 
  name: pod-with-requests-xyz
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
EOF
k -f pod.yaml apply
```

<details><summary>Tip</summary>

#TODO

</details>

<details><summary>Solution</summary>

#TODO

</details>
