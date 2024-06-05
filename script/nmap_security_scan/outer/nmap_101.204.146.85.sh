#!/bin/bash

nmap -sS -A -v --reason -p- -n -Pn -oA tcp 101.204.146.85 101.204.146.85
