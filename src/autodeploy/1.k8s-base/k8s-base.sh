#!/bin/bash
set -e

workDir=$WORK_DIR/1.k8s-base
echo ">>>>>>>> 1.k8s-base - Process......"

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

kubectl apply -f $workDir/yaml/namespace.yaml
kubectl apply -f $workDir/yaml/pv.yaml
kubectl apply -f $workDir/yaml/pvc.yaml
kubectl apply -f $workDir/yaml/nginx_conf.yaml

# 中心云不需要
if  [ ! "$ICAPLAT_CENTER_CENTER" = "true" ]; then
    # 部署不是中心云需要的组件
    kubectl apply -f $workDir/yaml/notcenter/namespace.yaml
    kubectl apply -f $workDir/yaml/notcenter/pv.yaml
    kubectl apply -f $workDir/yaml/notcenter/pvc.yaml
    kubectl apply -f $workDir/yaml/notcenter/sa.yaml
    kubectl apply -f $workDir/yaml/notcenter/nginx_conf.yaml
fi

exit 0
