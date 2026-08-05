#!/bin/bash

echo Verify solution

# Verify that the Validating Policy called check-labels still exists
policy_exists=$(kubectl get cpol check-labels --ignore-not-found)
if [ -z "$policy_exists" ]; then
    echo "Verification failed: Validating Policy 'check-labels' does not exist."
    exit 1
else
    echo "Verification successful: Validating Policy 'check-labels' exists."
fi

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
