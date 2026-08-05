https://kyverno.io/docs

## Verify that Kyverno has been installed correctly

Please run the following command:

```plain
kubectl get pod -n kyverno
```{{exec}}

You should see all Kyverno Pods in Running state.

## Create Policy
Let's create our first simple policy.
Create a simple policy that requires the *environment* label to be set at a Pod level.
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

Let's try to create a simple Pod.
We expect this to fail.
```
sleep 5 # wait till policy was implemented
k run nginx --image=nginx
```{{exec}}

## Try to respect the policy

Try to create a Pod with the name `nginx` in the namespace `default` that is allowed by our policy.

<details><summary>Tip</summary>

You can use the same command as before... Just add the label `environment` with any value.

</details>

<details><summary>Solution</summary>

```
k run nginx --image=nginx -l environment=prod
```{{exec}}

</details>
