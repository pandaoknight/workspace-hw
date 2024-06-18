#!/bin/bash

# Define color codes
YELLOW="\033[1;33m"
NO_COLOR="\033[0m"

# Function to check for and delete the gpu-manager Daemonset using a yaml file
delete_gpu_manager_daemonset() {
    echo -e "${YELLOW}GM-UNINSTALL(1/4) Checking for existing gpu-manager Daemonset...${NO_COLOR}"
    if kubectl get -f gpu-manager.template.yaml -n kube-system > /dev/null 2>&1; then
        kubectl delete -f gpu-manager.template.yaml -n kube-system
        echo -e "The gpu-manager Daemonset has been deleted.${NO_COLOR}"
    else
        echo -e "No existing gpu-manager Daemonset found.${NO_COLOR}"
    fi
}

# Function to check for and delete the gpu-manager service using a yaml file
delete_gpu_manager_service() {
    echo -e "${YELLOW}GM-UNINSTALL(2/4) Checking for existing gpu-manager service...${NO_COLOR}"
    if kubectl get -f gpu-manager-svc.yaml -n kube-system > /dev/null 2>&1; then
        kubectl delete -f gpu-manager-svc.yaml -n kube-system
        echo -e "The gpu-manager service has been deleted.${NO_COLOR}"
    else
        echo -e "No existing gpu-manager service found.${NO_COLOR}"
    fi
}

# Function to check for and delete the ClusterRoleBinding
delete_clusterrolebinding() {
    echo -e "${YELLOW}GM-UNINSTALL(3/4) Checking for existing gpu-manager ClusterRoleBinding...${NO_COLOR}"
    if kubectl get clusterrolebinding gpu-manager-role > /dev/null 2>&1; then
        kubectl delete clusterrolebinding gpu-manager-role
        echo -e "The gpu-manager ClusterRoleBinding has been deleted.${NO_COLOR}"
    else
        echo -e "No existing gpu-manager ClusterRoleBinding found.${NO_COLOR}"
    fi
}

# Function to check for and delete the ServiceAccount
delete_service_account() {
    echo -e "${YELLOW}GM-UNINSTALL(4/4) Checking for existing gpu-manager ServiceAccount...${NO_COLOR}"
    if kubectl get sa gpu-manager -n kube-system > /dev/null 2>&1; then
        kubectl delete sa gpu-manager -n kube-system
        echo -e "The gpu-manager ServiceAccount has been deleted.${NO_COLOR}"
    else
        echo -e "No existing gpu-manager ServiceAccount found.${NO_COLOR}"
    fi
}

# Main uninstall process
delete_gpu_manager_daemonset
delete_gpu_manager_service
delete_clusterrolebinding
delete_service_account

echo -e "${YELLOW}Uninstallation of gpu-manager components completed.${NO_COLOR}"

