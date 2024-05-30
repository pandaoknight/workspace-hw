#!/bin/bash

{
    echo "Namespace Name Status DCU_Usage"
    kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.spec.containers[].resources.requests."hygon.com/dcu" != null) | [.metadata.namespace, .metadata.name, .status.phase, (.spec.containers[].resources.requests."hygon.com/dcu")] | @tsv' | awk 'BEGIN {FS="\t"} {print $1, $2, $3, $4}'
} | column -t
