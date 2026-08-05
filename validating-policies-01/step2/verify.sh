#!/bin/bash

# Verify that the Validating Policy called require-requests exists in default namespace
policy_exists=$(kubectl get cpol require-requests --ignore-not-found)
if [ -z "$policy_exists" ]; then
    echo "Verification failed: Validating Policy 'require-requests' does not exist."
    exit 1
else
    echo "Verification successful: Validating Policy 'require-requests' exists."
fi

# Create a yaml file for a pod without resource requests
cat <<EOF > pod-no-requests.yaml
apiVersion: v1
kind: Pod
metadata: 
  name: pod-no-requests-xyz
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx
EOF

# Try to create the pod without resource requests and expect an error
kubectl create -f pod-no-requests.yaml --dry-run=client 2>&1 | grep -q "ValidationError" && echo "Verification successful: Pod creation failed as expected." || echo "Verification failed: Pod creation did not fail as expected."

# Try to create a pod with resource requests and expect success
cat <<EOF > pod-with-requests.yaml
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

# Apply the pod with resource requests and check if it was created successfully
kubectl apply -f pod-with-requests.yaml --dry-run=client 2>&1 | grep -q "pod/pod-with-requests created" && echo "Verification successful: Pod with resource requests created successfully." || echo "Verification failed: Pod with resource requests was not created successfully."


