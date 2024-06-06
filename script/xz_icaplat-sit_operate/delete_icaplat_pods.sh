#!/bin/bash


NAMESPACE="icaplat-sit"

delete_pods_with_prefix() {
  local prefix=$1
  echo "Searching for pods with prefix '$prefix'..."

  pods=$(kubectl get pods -n $NAMESPACE --no-headers=true | awk "/^$prefix/ {print \$1}")

  if [ -z "$pods" ]; then
    echo "No pods starting with '$prefix' found in the namespace $NAMESPACE."
  else
    for pod in $pods; do
      echo "Deleting pod $pod..."
      kubectl delete pod $pod -n $NAMESPACE
    done
  fi
}

delete_pods_with_prefix "icaplat-"

delete_pods_with_prefix "redis-"
