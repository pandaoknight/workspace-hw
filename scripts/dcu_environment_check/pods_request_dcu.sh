#!/bin/bash

{
    echo "Namespace Name Status"
    kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.spec.containers[].resources.requests."hygon.com/dcu" != null) | [.metadata.namespace, .metadata.name, .status.phase] | @tsv' | awk 'BEGIN {FS="\t"} {print $1, $2, $3}'
} | column -t
