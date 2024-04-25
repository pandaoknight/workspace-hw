#!/bin/bash

_tag=$(cat ./TAG)

docker save unionbigdata/notebook_ascend-mindspore:${_tag} -o unionbigdata_notebook_ascend-mindspore_${_tag}.tar
