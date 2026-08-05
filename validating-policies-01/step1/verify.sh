#!/bin/bash

echo Verify solution

# Count Pods with environment label set to anything
count=$(kubectl get pods -n default -l environment -o json | jq '.items | length')
echo "Number of pods with environment label: $count"

# Check if the count is greater than 0
if [ "$count" -gt 0 ]; then
    echo "Verification successful: Found $count pods with the 'environment' label."
    exit 0
else
    echo "Verification failed: No pods found with the 'environment' label."
    exit 1
fi
