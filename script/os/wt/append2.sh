#!/usr/bin/bash

# Source the utility functions
source /root/szl1160710/script/shell_utils/bashrc_utils.sh

KEY_PHRASE="# XCUsability watch-with-color-and-time-v2.0"
BASHRC_FILE="$HOME/.bashrc"

# Create a temporary file to hold the content
CONTENT_FILE=$(mktemp)

cat <<EOF >"$CONTENT_FILE"
alias wt='watch -c -n.2 time '
alias wl='watch -c "pwd && ls -l --color=always"'
#alias wc='watch -c "tree -C"' # This is a pretty bad alias override /usr/bin/wc
alias we='watch -c "tree -C"'
EOF

# Call the new function
update_bashrc "$KEY_PHRASE" "$BASHRC_FILE" "$CONTENT_FILE"

# Clean up
rm "$CONTENT_FILE" 
