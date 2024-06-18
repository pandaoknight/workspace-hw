#!/bin/bash
set -e

workDir=$WORK_DIR/8.file

echo ">>>>>>>> 8.file - Process......"

mkdir $workDir/nfs
#mount -t nfs ${ICAPLAT_K8S_NFS_HOST}:/${ICAPLAT_K8S_NFS_PATH}  $workDir/nfs
mount --bind ${ICAPLAT_K8S_NFS_PATH} $workDir/nfs

# 深度学习算子初始化
echo "copy operator....."

cd $workDir/nfs
echo "delete operator....."
rm -rf operator
mkdir -p operator/algplat/one/am
cd operator/algplat/one/am
mkdir public && mkdir mine
cp $workDir/icm-algorithms.tgz ./
tar -zxf icm-algorithms.tgz
## 根据算子ID复制
# 非中心云需要复制我的算子
if  [  "$ICAPLAT_CENTER_CENTER" = "false" ]; then
    for i in 1 2 3 4 5 6 ;do
      echo "copy mine operator id ${i}"
      cp -r icm-algorithms mine/${i}
    done
fi

# 非边端需要复制公关算子
if  [  "$ICAPLAT_CENTER_SIDE" = "false" ]; then
    for i in 19 20 21 22 23 24 ;do
      echo "copy public operator id ${i}"
      cp -r icm-algorithms public/${i}
    done
fi
rm -f icm-algorithms.tgz
rm -rf icm-algorithms

# notebook文件初始化
echo "copy notebook....."
cd $workDir/nfs
rm -rf notebook
mkdir -p notebook/algplat/one
cp  $workDir/notebook/help.ipynb notebook/algplat/one

# karmada文件初始化
if  [  "$ICAPLAT_CENTER_CENTER" = "true" ]; then
  echo "copy karmada....."
  cd $workDir/nfs
  rm -rf karmada
  mkdir  karmada
  cd $workDir
  cp   ../3.karmada/karmadactl-linux-amd64.tgz $workDir/nfs/karmada
fi

# 机器学习python
echo "copy python....."
cd $workDir/nfs
rm -rf train
mkdir -p train/algplat/file/python
cd train/algplat/file/python/
cp -r $workDir/icm-distributed-ml.tgz ./
tar -zxf icm-distributed-ml.tgz
rm -f icm-distributed-ml.tgz

# 引导页文件
echo "copy guide file....."
cd $workDir/nfs
rm -rf base/guide
if [ ! -d "$workDir/nfs/base" ]; then
    mkdir base
fi
cd base
mv $workDir/guide.tgz ./
tar -zxf guide.tgz
rm -f guide.tgz

##  close
cd $workDir
umount $workDir/nfs
