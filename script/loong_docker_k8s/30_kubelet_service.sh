#!/bin/bash

# Define the installation directory for the kubelet binary
#INSTALL_DIR="/usr/local/bin"
INSTALL_DIR="/usr/bin"

# Create the kubelet.service file
mkdir -p /etc/systemd/system/

cat <<EOF > /etc/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=${INSTALL_DIR}/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Created /etc/systemd/system/kubelet.service"

# Create the 10-kubeadm.conf file
mkdir -p /etc/systemd/system/kubelet.service.d

cat <<EOF > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/sysconfig/kubelet
ExecStart=
ExecStart=${INSTALL_DIR}/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_KUBEADM_ARGS \$KUBELET_EXTRA_ARGS
EOF

echo "Created /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

# Reload systemd to apply the new service configuration
systemctl daemon-reload
echo "Reloaded systemd daemon"

# Enable the kubelet service so it starts on boot
systemctl enable kubelet
echo "Enabled kubelet service"

# Start the kubelet service immediately
systemctl start kubelet
echo "Started kubelet service"
