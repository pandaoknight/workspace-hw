# k8s 1.29.0 部署

## 依赖软件
    docker 24.0.7
    systemctl stop firewalld && systemctl disable firewalld
    swapoff -a
    cri-dockerd 0.3.8
---
## 配置cri-dockerd启动项
1. cri-docker.service
````
cat > /etc/systemd/system/cri-docker.service<<EOF

[Unit]
Description=CRI Interface for Docker Application Container Engine
Documentation=https://docs.mirantis.com
After=network-online.target firewalld.service docker.service
Wants=network-online.target
Requires=cri-docker.socket

[Service]
Type=notify
#ExecStart=/usr/local/bin/cri-dockerd --container-runtime-endpoint fd://
ExecStart=/usr/local/bin/cri-dockerd --pod-infra-container-image=lcr.loongnix.cn/kubernetes/pause:3.9 --container-runtime-endpoint fd://
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
````
---
2. cri-docker.socket

````
cat > /etc/systemd/system/cri-docker.socket <<EOF

[Unit]
Description=CRI Docker Socket for the API
PartOf=cri-docker.service

[Socket]
ListenStream=%t/cri-dockerd.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF
````
---
3. systemctl daemon-reload 
````
systemctl enable cri-docker && systemctl start cri-docker && systemctl status cri-docker 
````
---
## 安装kubelet kubeadm kubectl

### 配置kubelet启动项
1. 配置cgroup 驱动与docker一致
````
cat > /etc/sysconfig/kubelet <<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"
EOF
````

````
systemctl enable kubelet
````
---
### k8s镜像版本
```
lcr.loongnix.cn/kubernetes/kube-apiserver:v1.29.0
lcr.loongnix.cn/kubernetes/kube-controller-manager:v1.29.0
lcr.loongnix.cn/kubernetes/kube-scheduler:v1.29.0
lcr.loongnix.cn/kubernetes/kube-proxy:v1.29.0
lcr.loongnix.cn/kubernetes/coredns:v1.11.1
lcr.loongnix.cn/kubernetes/pause:3.9
lcr.loongnix.cn/kubernetes/etcd:3.5.10-0
```
---
### calico版本 v3.27.0

### 部署k8s
````
sudo kubeadm init \
--image-repository lcr.loongnix.cn/kubernetes \
--kubernetes-version v1.29.0 \
--cri-socket=unix:///var/run/cri-dockerd.sock \
-v=5
````



