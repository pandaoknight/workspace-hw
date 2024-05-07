#!/bin/bash

_tag=$(cat ./TAG)

docker push unionbigdata/notebook_ascend-mindspore:${_tag}
