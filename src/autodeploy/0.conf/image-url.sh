#!/bin/bash

workDir=`cd $(dirname $0); pwd`

if [ -n "$1" ]
then
    kubectl get deployments -n $1 -o jsonpath="{..image}" |\
    tr -s '[[:space:]]' '\n' |\
    sort |\
    uniq -c   > $workDir/image_url.yaml

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-algorithm-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_ALGORITHM_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-base | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_BASE=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-dataset | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_DATASET=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-dispatcher | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_DISPATCHER=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-gateway | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_GATEWAY=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-help-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_HELP_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-label | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_LABEL=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-label-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_LABEL_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-model | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_MODEL=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-operator | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_OPERATOR=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-portal-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_PORTAL_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-predict | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_PREDICT=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep icaplat-train | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_TRAIN=${image_url}"


    image_url="$(cat $workDir/image_url.yaml | grep xs-data-mgt-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_DATA_MGT_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep xs-database | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_DATABASE=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep xs-filemgt | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_FILE=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep szl-center-system | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_MGT=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep xs-mgt-web | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_MGT_WEB=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep szl-center-auth | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_SSO=${image_url}"

    image_url="$(cat $workDir/image_url.yaml | grep xs-theme | awk 'NR==1{print $2}')"
    echo -e "ICAPLAT_K8S_IMAGE_THEME=${image_url}"

else
    echo "namespace null "
fi


