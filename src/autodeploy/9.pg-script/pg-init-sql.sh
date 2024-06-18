#!/bin/bash

workDir=$WORK_DIR/9.pg-script
SQL_FILES=$workDir/sql/*.sql

echo ">>>>>>>> 9.pg-script - Process......"

while read -r line; do
  if [[ $line =~ ^#.*$ ]]; then
    continue
  fi;

  if [[ $line =~ ^\s*$ ]]; then
    continue
  fi;

  key=$(echo $line | cut -d'=' -f1 | sed 's/^\s*//g' | sed 's/\s*$//g')
  value=$(echo $line | cut -d'=' -f2- | sed 's/^\s*//g' | sed 's/\s*$//g')

  for file in $SQL_FILES;do
      sed -i "s#\${$key}#$value#g" $file
       #sed命令引起的^M问题解决
      sed -i "s/\r//g" $file
  done

done < $XZ_CONFIG_FILE

for deploy in "postgresql"  "icaplat-base" "icaplat-model" "icaplat-operator" ;do
  while true;do
    readyNum=$(kubectl get deployment $deploy  -n $ICAPLAT_K8S_MAIN_NAMESPACE  -o=jsonpath='{.status.readyReplicas}')
    readyNum=${readyNum:=0}
    echo "$deploy READY num is $readyNum"
    if [ $readyNum -gt 0 ]; then
       break
    else
        status=$(kubectl get pod -n $ICAPLAT_K8S_MAIN_NAMESPACE |grep $deploy | awk 'NR==1{print $3}')
         echo "$deploy status $status"
    fi
        sleep 5
  done
done

postgresql_pod=$(kubectl get pod -n $ICAPLAT_K8S_MAIN_NAMESPACE |grep postgresql | awk 'NR==1{print $1}')

echo "base init..."
kubectl cp $workDir/sql/base.sql $ICAPLAT_K8S_MAIN_NAMESPACE/$postgresql_pod:/var/lib/postgresql/tmp.sql
kubectl exec  $postgresql_pod -n $ICAPLAT_K8S_MAIN_NAMESPACE --request-timeout=120s -- psql -U icaplat -d icaplat-base -f /var/lib/postgresql/tmp.sql  >/dev/null

echo "model init..."
kubectl cp $workDir/sql/model.sql $ICAPLAT_K8S_MAIN_NAMESPACE/$postgresql_pod:/var/lib/postgresql/tmp.sql
kubectl exec  $postgresql_pod -n $ICAPLAT_K8S_MAIN_NAMESPACE --request-timeout=120s -- psql -U icaplat -d icaplat-model -f /var/lib/postgresql/tmp.sql  >/dev/null

echo "operator init..."
kubectl cp $workDir/sql/operator.sql $ICAPLAT_K8S_MAIN_NAMESPACE/$postgresql_pod:/var/lib/postgresql/tmp.sql
kubectl exec  $postgresql_pod -n $ICAPLAT_K8S_MAIN_NAMESPACE --request-timeout=120s -- psql -U icaplat -d icaplat-operator -f /var/lib/postgresql/tmp.sql  >/dev/null
