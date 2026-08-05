https://kyverno.io/docs

## Verify that Kyverno has been installed correctly

```plain
kubectl get pod -n kyverno
```{{exec}}

## Create Policy
Create a simple policy that requires certain *Pod* labels to be set:
```
cat <<EOF > pod-require-env-label.yaml
apiVersion: policies.kyverno.io/v1
kind: ValidatingPolicy
metadata:
  name: check-labels
spec:
  validationActions:
    - Deny
  matchConstraints:
    resourceRules:
      - apiGroups: ['']
        apiVersions: [v1]
        operations: [CREATE, UPDATE]
        resources: [pods]
  validations:
    - message: label 'environment' is required
      expression: "'environment' in object.metadata.?labels.orValue([])"
EOF
k -f pod-require-env-label.yaml apply
```{{exec}}

## Test
Creating a pod without required labels is not possible
```
sleep 5 # wait till policy was implemented
k run nginx --image=nginx
```{{exec}}
