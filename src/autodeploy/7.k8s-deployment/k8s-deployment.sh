#!/bin/bash
set -e

workDir=$WORK_DIR/7.k8s-deployment
echo ">>>>>>>> 7.k8s-deployment - Process......"

while read -r line; do
  if [[ $line =~ ^#.*$ ]]; then
    continue
  fi;

  if [[ $line =~ ^\s*$ ]]; then
    continue
  fi;

  key=$(echo $line | cut -d'=' -f1 | sed 's/^\s*//g' | sed 's/\s*$//g')
  value=$(echo $line | cut -d'=' -f2- | sed 's/^\s*//g' | sed 's/\s*$//g')

  find  $workDir -type f -name "*.yaml" -print0 | while IFS= read -r -d '' file; do
      sed -i "s#\${$key}#$value#g" $file
            #sed命令引起的^M问题解决
      sed -i "s/\r//g" $file
  done

done < $XZ_CONFIG_FILE

kubectl apply -f $workDir/component  -n $ICAPLAT_K8S_MAIN_NAMESPACE

if [ -n "$ICAPLAT_OUT_PORT_PG" ]; then
  kubectl apply -f $workDir/component/export/postgresql.yaml -n $ICAPLAT_K8S_MAIN_NAMESPACE
fi

if [ -n "$ICAPLAT_OUT_PORT_REDIS" ]; then
  kubectl apply -f $workDir/component/export/redis.yaml  -n $ICAPLAT_K8S_MAIN_NAMESPACE
fi
if [ -n "$ICAPLAT_OUT_PORT_NACOS" ]; then
  kubectl apply -f $workDir/component/export/nacos.yaml  -n $ICAPLAT_K8S_MAIN_NAMESPACE
fi

# 中心云不需要
if  [ ! "$ICAPLAT_CENTER_CENTER" = "true" ]; then
    # 部署不是中心云需要的组件
    kubectl apply -f $workDir/component/notcenter  -n $ICAPLAT_K8S_MAIN_NAMESPACE
    sleep 5
    # 安装cert-manager
    kubectl apply -f $workDir/operator/cert-manager.yaml
    sleep 10
    # 安装flink
    if kubectl get deployment -n flink-operator &> /dev/null; then
        kubectl delete deployment --all -n flink-operator
    fi
    if helm -n flink-operator  ls -a |grep -q flink-operator; then
        helm -n flink-operator  delete flink-operator
    fi
    helm  install -n flink-operator flink-operator $workDir/operator/flink
    sleep 2
    # 安装vCUDA
    #bash $workDir/operator/vcuda/install.sh
fi

echo ">>> wait 60s"
sleep 60s

while true;do
    status=$(kubectl get pod -n $ICAPLAT_K8S_MAIN_NAMESPACE |grep postgresql | awk 'NR==1{print $3}')
    echo "postgresql status $status"
    if  [ "$status"x = "Running"x ]; then
        break
    fi
    sleep 1
done


kubectl apply -f $workDir/integrate -n $ICAPLAT_K8S_MAIN_NAMESPACE
if  [ ! "$ICAPLAT_CENTER_CENTER" = "true" ]; then
  kubectl apply -f $workDir/integrate/notcenter -n $ICAPLAT_K8S_MAIN_NAMESPACE
fi
echo ">>> wait 60s"
sleep 60s

kubectl apply -f $workDir/business -n $ICAPLAT_K8S_MAIN_NAMESPACE
if  [ ! "$ICAPLAT_CENTER_CENTER" = "true" ]; then
  kubectl apply -f $workDir/business/notcenter -n $ICAPLAT_K8S_MAIN_NAMESPACE
fi

exit 0
