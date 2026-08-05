#!/bin/bash

echo Start install kyverno

helm repo add kyverno https://kyverno.github.io/kyverno
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace --set replicaCount=1
kubectl wait deployment -n kyverno -l app.kubernetes.io/instance=kyverno --for condition=Available=True --timeout=2m
