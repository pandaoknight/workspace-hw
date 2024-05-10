#!/bin/bash

_tag=$(cat ./TAG)

docker build -t unionbigdata/root_ascend-pytorch:${_tag} .
