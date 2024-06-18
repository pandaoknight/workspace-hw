#!/usr/bin/bash

kubectl create sa gpu-manager -n kube-system
kubectl create clusterrolebinding gpu-manager-role --clusterrole=cluster-admin --serviceaccount=kube-system:gpu-manager
