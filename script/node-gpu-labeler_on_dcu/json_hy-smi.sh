#!/bin/bash

hy-smi --showmeminfo vram --showproductname --json|jq
