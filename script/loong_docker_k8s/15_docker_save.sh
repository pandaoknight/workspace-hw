#!/bin/bash -x

mkdir -p downloads/docker_images
cd downloads/docker_images

docker save -o lcr_k8s_coredns_v1.11.1.tar lcr.loongnix.cn/kubernetes/coredns:v1.11.1
docker save -o lcr_k8s_etcd_3.5.10-0.tar lcr.loongnix.cn/kubernetes/etcd:3.5.10-0
docker save -o lcr_k8s_kube-apiserver_v1.29.0.tar lcr.loongnix.cn/kubernetes/kube-apiserver:v1.29.0
docker save -o lcr_k8s_kube-controller-manager_v1.29.0.tar lcr.loongnix.cn/kubernetes/kube-controller-manager:v1.29.0
docker save -o lcr_k8s_kube-proxy_v1.29.0.tar lcr.loongnix.cn/kubernetes/kube-proxy:v1.29.0
docker save -o lcr_k8s_kube-scheduler_v1.29.0.tar lcr.loongnix.cn/kubernetes/kube-scheduler:v1.29.0
docker save -o lcr_k8s_pause_3.9.tar lcr.loongnix.cn/kubernetes/pause:3.9

#tar -cvzf lcr_k8s_coredns_v1.11.1.tar.gz lcr_k8s_coredns_v1.11.1.tar
#tar -cvzf lcr_k8s_etcd_3.5.10-0.tar.gz lcr_k8s_etcd_3.5.10-0.tar
#tar -cvzf lcr_k8s_kube-apiserver_v1.29.0.tar.gz lcr_k8s_kube-apiserver_v1.29.0.tar
#tar -cvzf lcr_k8s_kube-controller-manager_v1.29.0.tar.gz lcr_k8s_kube-controller-manager_v1.29.0.tar
#tar -cvzf lcr_k8s_kube-proxy_v1.29.0.tar.gz lcr_k8s_kube-proxy_v1.29.0.tar
#tar -cvzf lcr_k8s_kube-scheduler_v1.29.0.tar.gz lcr_k8s_kube-scheduler_v1.29.0.tar
#tar -cvzf lcr_k8s_pause_3.9.tar.gz lcr_k8s_pause_3.9.tar

#rm -f lcr_k8s_coredns_v1.11.1.tar
#rm -f lcr_k8s_etcd_3.5.10-0.tar
#rm -f lcr_k8s_kube-apiserver_v1.29.0.tar
#rm -f lcr_k8s_kube-controller-manager_v1.29.0.tar
#rm -f lcr_k8s_kube-proxy_v1.29.0.tar
#rm -f lcr_k8s_kube-scheduler_v1.29.0.tar
#rm -f lcr_k8s_pause_3.9.tar


# tar.gz not effective, error:
# PS C:\Users\PC\Downloads> docker load -i lcr_k8s_coredns_v1.11.1.tar.gz
# open /var/lib/docker/tmp/docker-import-2781389346/repositories: no such file or directory
