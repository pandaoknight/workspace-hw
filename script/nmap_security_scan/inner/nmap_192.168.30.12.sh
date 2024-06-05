#!/bin/bash

nmap -sS -A -v --reason -p- -n -Pn -oA tcp 192.168.30.12 192.168.30.12
