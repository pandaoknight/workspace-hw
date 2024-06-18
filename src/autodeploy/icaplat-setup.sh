#!/bin/bash
set -e

workDir=`cd $(dirname $0); pwd`
echo "$workDir"

echo ">>> file backup"

if mountpoint -q $workDir/tmp/8.file/nfs
then
  umount $workDir/tmp/8.file/nfs
fi
rm -rf $workDir/tmp
mkdir $workDir/tmp
cp -r `ls $workDir |grep -v tmp|xargs` $workDir/tmp/

workDir=$workDir/tmp

export XZ_CONFIG_FILE=$workDir/0.conf/icaplat-config.properties
export WORK_DIR=$workDir

echo ">>> WORK_DIR $workDir"
##  读取K8S config
kubectl config view --raw > $workDir/kubeconfig.yaml
certificate_authority_data="$(cat $workDir/kubeconfig.yaml | grep certificate-authority-data | awk 'NR==1{print $2}')"
client_certificate_data="$(cat $workDir/kubeconfig.yaml | grep client-certificate-data | awk 'NR==1{print $2}')"
client_key_data="$(cat $workDir/kubeconfig.yaml | grep client-key-data | awk 'NR==1{print $2}')"

echo -e "icaplat_k8s_certificate_authority_data=${certificate_authority_data}\n" >> $XZ_CONFIG_FILE
echo -e "icaplat_k8s_client_certificate_data=${client_certificate_data}\n" >> $XZ_CONFIG_FILE
echo -e "icaplat_k8s_client_key_data=${client_key_data}\n" >> $XZ_CONFIG_FILE

readConfig() {
  sed -i -e 's/^M//' $XZ_CONFIG_FILE
  IFS=';'
  array+=("WORK_DIR" "$workDir")
  # 读取xs-config.properties配置文件
  while read -r line; do
    if [[ $line =~ ^#.*$ ]]; then
      continue
    fi
    if [[ $line =~ ^\s*$ ]]; then
      continue
    fi

    key=$(echo $line | cut -d'=' -f1 | sed 's/^\s*//g' | sed 's/\s*$//g')
    value=$(echo $line | cut -d'=' -f2- | sed 's/^\s*//g' | sed 's/\s*$//g')
    array+=("$key" "$value")
    if [[ $line =~ ^ICAPLAT.*$ ]]; then
      export $key=$value
    fi

  done < $XZ_CONFIG_FILE
  # printf "  %-30s | %-120s\n" "${array[@]}"
}

readConfig

# 先删除pv\ns（pv创建后不可修改）
echo "delete ns & pv ...."
for suffix in "" "-dev-notebook" "-estimate-model" "-serving-model" "-train-automodel" "-train-workflow" "-serving-workflow" "-transformer-model" ;do
  if kubectl get namespace ${ICAPLAT_K8S_MAIN_NAMESPACE}${suffix} > /dev/null 2>&1 ; then
      kubectl delete ns ${ICAPLAT_K8S_MAIN_NAMESPACE}${suffix}
  fi
  if kubectl get  pv ${ICAPLAT_K8S_MAIN_NAMESPACE}${suffix}-pv > /dev/null 2>&1 ; then
    kubectl delete pv ${ICAPLAT_K8S_MAIN_NAMESPACE}${suffix}-pv
  fi
done

echo "check port...."
for portName in "ICAPLAT_OUT_PORT_WEB" "ICAPLAT_OUT_PORT_PG" "ICAPLAT_OUT_PORT_NACOS" "ICAPLAT_OUT_PORT_REDIS" "ICAPLAT_OUT_PORT_MYSQL";do
  port=${!portName}
  if [ $port ]; then
      if kubectl get service -A |grep $port ;then
          echo ">>> ${port} provided port is already allocated"
          exit -1
      fi
  fi
done

if  [ "$ICAPLAT_CENTER_CENTER" = "true" ] && [ "$ICAPLAT_CENTER_SIDE" = "true" ] ; then
   echo "ICAPLAT_CENTER_CENTER AND ICAPLAT_CENTER_SIDE both true !!!!!"
   exit -1
fi

find  $workDir -type f -name "*.sh" -print0 | while IFS= read -r -d '' file; do
  sed -i "s/\r//" $file
done

mysqlConfig(){
  sed -i '/ICAPLAT_MYSQL_HOST/d' $XZ_CONFIG_FILE
  sed -i '/ICAPLAT_MYSQL_PORT/d' $XZ_CONFIG_FILE
  sed -i '/ICAPLAT_MYSQL_USER/d' $XZ_CONFIG_FILE
  sed -i '/ICAPLAT_MYSQL_PASSWORD/d' $XZ_CONFIG_FILE
  sed -i '/ICAPLAT_MYSQL_PASSWORD_ENC/d' $XZ_CONFIG_FILE

  echo -e "ICAPLAT_MYSQL_HOST=mysql\n" >> $XZ_CONFIG_FILE
  echo -e "ICAPLAT_MYSQL_PORT=3306\n" >> $XZ_CONFIG_FILE
  echo -e "ICAPLAT_MYSQL_USER=root\n" >> $XZ_CONFIG_FILE
  echo -e "ICAPLAT_MYSQL_PASSWORD=123456\n" >> $XZ_CONFIG_FILE
  echo -e "ICAPLAT_MYSQL_PASSWORD_ENC=K9SUaFib+5hE/0cGlOK5ao05+fLD4ZV85cHFN42wf2ddXpYMPYOWhcgkM7swnhOkIhNEUhwOx5XOiQAwgKqLNA==\n" >> $XZ_CONFIG_FILE
}

if  [ "$ICAPLAT_MYSQL_INNER" = "true" ]; then
  export namespace_mysql=$ICAPLAT_K8S_MAIN_NAMESPACE;
  mysqlConfig
else
  export namespace_mysql="icaplat-mysql-tmp";
fi

bash $workDir/1.k8s-base/k8s-base.sh

#bash $workDir/2.db-script/mysq-init-sql.sh


## if centerCluster
if  [ "$ICAPLAT_CENTER_CENTER" = "true" ]; then
    bash $workDir/3.karmada/karmada-setup.sh
fi

#bash $workDir/4.nacos/nacos-setup.sh

bash $workDir/7.k8s-deployment/k8s-deployment.sh

bash $workDir/8.file/file_init.sh

bash $workDir/9.pg-script/pg-init-sql.sh

echo ">>> close"

if kubectl get ns |grep icaplat-mysql-tmp ;then
  kubectl delete ns icaplat-mysql-tmp
fi
