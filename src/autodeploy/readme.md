# 环境要求
1 第一步先将加载镜像后上传到私服harbor，如不使用harbor需要将镜像加载到每一个节点
2 需要提供一个mysql5.7的数据库
3 上传安装文件，并按照部署环境实际参数更改配置文件： 0.conf/icaplat-config.properties
4 给脚本赋予执行权限并执行
    chmod +x icaplat-setup.sh && sed -i 's/\r//' icaplat-setup.sh && ./icaplat-setup.sh
