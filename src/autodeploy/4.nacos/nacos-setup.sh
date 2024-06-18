#!/bin/bash
set -e

workDir=$WORK_DIR/4.nacos
NACOS_INIT_SQL=$workDir/nacos-mysql.sql
NACOS_CONFIG_FILES=$workDir/config/*.*

echo ">>>>>>>> 4.nacos - Process......"

#读取xs-config.properties配置文件，然后遍历配置文件替换配置变量
while read line; do
if [[ $line =~ ^#.*$ ]]; then
    continue
  fi;

  if [[ $line =~ ^\s*$ ]]; then
    continue
  fi;

  key=$(echo $line | cut -d'=' -f1 | sed 's/^\s*//g' | sed 's/\s*$//g')
  value=$(echo $line | cut -d'=' -f2- | sed 's/^\s*//g' | sed 's/\s*$//g')

  for file in $NACOS_CONFIG_FILES;do
    #echo "sed -i s#\$\{$key\}#$value#g $file"
    sed -i "s#\${$key}#$value#g" $file
     #sed命令引起的^M问题解决
    sed -i "s/\r//g" $file
  done

  sed -i "s#\${$key}#$value#g" $NACOS_INIT_SQL
       #sed命令引起的^M问题解决
  sed -i "s/\r//g" $NACOS_INIT_SQL

done < $XZ_CONFIG_FILE

cd $workDir

mysql_pod=$(kubectl get pod -n $namespace_mysql |grep mysql | awk 'NR==1{print $1}')


# 初始化nacos数据库
echo "  init nacos database"
if  [ "$ICAPLAT_MYSQL_INNER" = "true" ]; then
  kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql  -u "root" -p"123456" "mysql" < $NACOS_INIT_SQL  2>/dev/null
else
  kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql -h "$ICAPLAT_MYSQL_HOST" -P "$ICAPLAT_MYSQL_PORT" -u "$ICAPLAT_MYSQL_USER" -p"$ICAPLAT_MYSQL_PASSWORD" "mysql" < $NACOS_INIT_SQL  2>/dev/null
fi


# nacos配置
echo -e "use ${ICAPLAT_NACOS_DB};\n" > $workDir/tmp.sql
for file in $NACOS_CONFIG_FILES;do
  echo "  build sql of $file"
  md5_value=`md5sum $file |awk '{print $1}'`
  data_id="${file##*/}"
  type="${file##*.}"
  if [[ $type == 'yml' ]]; then
    type='yaml'
  fi
  content=$(cat "$file" | sed -e "s/'/\\\'/g")
  echo -e "INSERT INTO config_info (data_id,group_id,content,md5,src_user,src_ip,app_name,tenant_id,type,encrypted_data_key) VALUES ('${data_id}','DEFAULT_GROUP','${content}','${md5_value}','nacos','127.0.0.1','','icaplat-config','${type}','');\n" >> $workDir/tmp.sql

done

echo "  execute batch_insert_sql"

if  [ "$ICAPLAT_MYSQL_INNER" = "true" ]; then
  kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql -u "root" -p"123456" "mysql" --default-character-set=utf8 < $workDir/tmp.sql 2>/dev/null
else
  kubectl exec -it $mysql_pod -n $namespace_mysql --request-timeout=120s -- mysql -h "$ICAPLAT_MYSQL_HOST" -P "$ICAPLAT_MYSQL_PORT" -u "$ICAPLAT_MYSQL_USER" -p"$ICAPLAT_MYSQL_PASSWORD" "mysql" --default-character-set=utf8 < $workDir/tmp.sql 2>/dev/null
fi

exit 0
