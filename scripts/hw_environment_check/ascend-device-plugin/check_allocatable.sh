#!/bin/bash

kubectl describe node | grep -i 'Alloc' -A12
