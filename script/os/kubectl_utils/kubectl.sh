#!/usr/bin/bash

# Source the utility functions
source /root/szl1160710/script/shell_utils/bashrc_utils.sh

KEY_PHRASE="# XCUsability kubctl alias v1.0"
BASHRC_FILE="$HOME/.bashrc"

# Create a temporary file to hold the content
CONTENT_FILE=$(mktemp)

cat <<EOF >"$CONTENT_FILE"
source <(kubectl completion bash)

alias k=kubectl
complete -o default -F __start_kubectl k
EOF

# Call the new function
update_bashrc "$KEY_PHRASE" "$BASHRC_FILE" "$CONTENT_FILE"

# Clean up
rm "$CONTENT_FILE" 
