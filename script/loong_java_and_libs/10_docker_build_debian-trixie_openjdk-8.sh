#!/bin/bash

docker build . -f debian-trixie_openjdk-8.dockerfile -t harbor.xnunion.com/lcr/debian-trixie_openjdk-8:latest
