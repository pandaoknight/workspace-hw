#!/bin/bash -x

journalctl -u kubelet --rotate
journalctl -u kubelet --vacuum-time=1s
journalctl -u kubelet -f
