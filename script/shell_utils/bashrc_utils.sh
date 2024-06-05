#!/usr/bin/bash

function check_key_phrase() {
    local KEY_PHRASE="$1"
    local FILE="$2"

    # Check if the key phrase already exists in the file
    if grep -q "$KEY_PHRASE" "$FILE"; then
        echo "The key phrase '$KEY_PHRASE' already exists in $FILE. No changes were made."
	echo "---------------"
	grep -a5 "$KEY_PHRASE" "$FILE" --color=auto
	echo "---------------"
        return 1
    fi

    return 0
}

function append_code_block() {
    local KEY_PHRASE="$1"
    local FILE="$2"
    local CONTENT_FILE="$3"

    # If the key phrase does not exist, append the code to the end of the file
    echo "Appending code block to $FILE..."
    echo "" >> "$FILE"
    echo "$KEY_PHRASE" >> "$FILE"
    cat "$CONTENT_FILE" >> "$FILE"
    echo "Done."

	echo "---------------"
	grep -a5 "$KEY_PHRASE" "$FILE" --color=auto
	echo "---------------"
    echo -e "\e[1;32mExecute following command to take effect!\e[0m"
    echo -e "\tsource $FILE"
}

function update_bashrc() {
    local KEY_PHRASE="$1"
    local FILE="$2"
    local CONTENT_FILE="$3"

    if check_key_phrase "$KEY_PHRASE" "$FILE"; then
        append_code_block "$KEY_PHRASE" "$FILE" "$CONTENT_FILE"
    fi
} 
