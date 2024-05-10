#!/bin/bash

POD_NAME=$(kubectl get pods --namespace default -l app=jupyter-notebook -o jsonpath="{.items[0].metadata.name}")

kubectl exec --namespace default -it $POD_NAME -- /bin/bash
