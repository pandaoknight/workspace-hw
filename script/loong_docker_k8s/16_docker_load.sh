#!/bin/bash -x

docker load -i lcr_k8s_coredns_v1.11.1.tar
docker load -i lcr_k8s_etcd_3.5.10-0.tar
docker load -i lcr_k8s_kube-apiserver_v1.29.0.tar
docker load -i lcr_k8s_kube-controller-manager_v1.29.0.tar
docker load -i lcr_k8s_kube-proxy_v1.29.0.tar
docker load -i lcr_k8s_kube-scheduler_v1.29.0.tar
docker load -i lcr_k8s_pause_3.9.tar

#docker load -i lcr_k8s_coredns_v1.11.1.tar.gz
#docker load -i lcr_k8s_etcd_3.5.10-0.tar.gz
#docker load -i lcr_k8s_kube-apiserver_v1.29.0.tar.gz
#docker load -i lcr_k8s_kube-controller-manager_v1.29.0.tar.gz
#docker load -i lcr_k8s_kube-proxy_v1.29.0.tar.gz
#docker load -i lcr_k8s_kube-scheduler_v1.29.0.tar.gz
#docker load -i lcr_k8s_pause_3.9.tar.gz
