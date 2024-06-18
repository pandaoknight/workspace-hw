#!/bin/bash

workDir=$WORK_DIR/2.db-script
mysqlYaml=$workDir/mysql.yaml
echo ">>>>>>>> 2.db-script - Process......"


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

if  [ "$ICAPLAT_MYSQL_INNER" = "true" ]; then
  kubectl apply -f $workDir/mysql.yaml -n $namespace_mysql

  if [ -n "$ICAPLAT_OUT_PORT_MYSQL" ]; then
    kubectl apply -f $workDir/export/mysql.yaml  -n $namespace_mysql
  fi
else
  kubectl apply -f $workDir/mysql-tmp.yaml -n $namespace_mysql
fi


while true;do
   readyNum=$(kubectl get deployment mysql  -n $namespace_mysql  -o=jsonpath='{.status.readyReplicas}')
   readyNum=${readyNum:=0}
    if  [ $readyNum -gt 0 ]; then
      break
    else
      status=$(kubectl get pod -n $namespace_mysql  |grep mysql | awk 'NR==1{print $3}')
      echo "mysql status $status"
    fi
    sleep 1
done

mysql_pod=$(kubectl get pod -n $namespace_mysql  |grep mysql | awk 'NR==1{print $1}')

max_retries=30
retry_count=0

# 中心云配置不一样
if  [ "$ICAPLAT_CENTER_CENTER" = "true" ]; then
  SQL_FILES=$workDir/xs/center/*.sql
else
  SQL_FILES=$workDir/xs/notcenter/*.sql
fi
echo "$namespace_mysql"
for file in $SQL_FILES;do
  echo "$file"
  while true; do
    if  [ "$ICAPLAT_MYSQL_INNER" = "true" ]; then
      kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql  -u "root" -p"123456" "mysql" < $file  2>/dev/null
    else
      kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql -h "$ICAPLAT_MYSQL_HOST" -P "$ICAPLAT_MYSQL_PORT" -u "$ICAPLAT_MYSQL_USER" -p"$ICAPLAT_MYSQL_PASSWORD" "mysql" < $file  2>/dev/null
    fi

    exit_status=$?
    if [ $exit_status -eq 0 ]; then
        echo "sql executed successfully."
        break
    else
        retry_count=$((retry_count + 1))
        echo "sql failed $retry_count "
        if [ $retry_count -gt $max_retries ] ;then
          echo "exit..."
          exit 1
        else
          echo "Retrying..."
          sleep 5
        fi

    fi
  done
done




