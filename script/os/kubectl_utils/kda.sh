#!/usr/bin/bash

# Source the utility functions
source /root/szl1160710/script/shell_utils/bashrc_utils.sh

KEY_PHRASE="# XCUsability kda-v2.0"
BASHRC_FILE="$HOME/.bashrc"

# Create a temporary file to hold the content
CONTENT_FILE=$(mktemp)

cat <<EOF >"$CONTENT_FILE"
function kda() {
  kubectl delete -f \$1
  kubectl apply -f \$1
}

function kd() {
  kubectl delete -f \$1
}

function ka() {
  kubectl apply -f \$1
}
EOF

# Call the new function
update_bashrc "$KEY_PHRASE" "$BASHRC_FILE" "$CONTENT_FILE"

# Clean up
rm "$CONTENT_FILE"
