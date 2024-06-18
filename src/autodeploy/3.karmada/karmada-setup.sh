#!/bin/bash
set -e

workDir=$WORK_DIR/3.karmada

echo ">>>>>>>> 3.karmada - Process......"

if kubectl get  ns karmada-system  > /dev/null 2>&1 ; then
  echo ">>> delete ns karmada-system"
  kubectl delete ns karmada-system
fi

tar zxvf $workDir/karmadactl-linux-amd64.tgz  -C $workDir/

echo ">>>>>>>> karmadactl init"
if  [ "$ICAPLAT_K8S_ONLINE" = "true" ]; then
  $workDir/karmadactl init --crds $workDir/crds.tar.gz > /dev/null 2>&1
else
  $workDir/karmadactl init --crds $workDir/crds.tar.gz --karmada-aggregated-apiserver-image="$ICAPLAT_K8S_IMAGE_karmada_aggregated_apiserver" \
      --karmada-controller-manager-image="$ICAPLAT_K8S_IMAGE_karmada_controller_manager" \
      --karmada-scheduler-image="$ICAPLAT_K8S_IMAGE_karmada_scheduler" \
      --karmada-webhook-image="$ICAPLAT_K8S_IMAGE_karmada_webhook" \
      --karmada-apiserver-image="$ICAPLAT_K8S_IMAGE_karmada_apiserver" \
      --karmada-kube-controller-manager-image="$ICAPLAT_K8S_IMAGE_karmada_kube_controller_manager" \
      --etcd-image="$ICAPLAT_K8S_IMAGE_karmada_etcd" \
      --etcd-init-image="$ICAPLAT_K8S_IMAGE_karmada_etcd_init" > /dev/null 2>&1


fi

karmada_discovery_token_ca_cert_hash="$($workDir/karmadactl token create --print-register-command --kubeconfig /etc/karmada/karmada-apiserver.config | awk 'NR==1{print $7}' | cut -c 8-)"
echo -e "icaplat_karmada_discovery-token-ca-cert-hash=${karmada_discovery_token_ca_cert_hash}\n" >> $XZ_CONFIG_FILE

karmada_caCert_data="$(cat /etc/karmada/karmada-apiserver.config | grep certificate-authority-data | awk 'NR==1{print $2}')"
karmada_client_cert_data="$(cat /etc/karmada/karmada-apiserver.config | grep client-certificate-data | awk 'NR==1{print $2}')"
karmada_client_key_data="$(cat /etc/karmada/karmada-apiserver.config | grep client-key-data | awk 'NR==1{print $2}')"
echo -e "icaplat_karmada_caCert-data=${karmada_caCert_data}\n" >> $XZ_CONFIG_FILE
echo -e "icaplat_karmada_client-cert-data=${karmada_client_cert_data}\n" >> $XZ_CONFIG_FILE
echo -e "icaplat_karmada_client-key-data=${karmada_client_key_data}\n" >> $XZ_CONFIG_FILE