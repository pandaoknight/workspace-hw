#!/bin/bash

#
tree /etc/yum.repos.d/
cat /etc/yum.repos.d/*.repo

#
dnf clean all
dnf makecache
