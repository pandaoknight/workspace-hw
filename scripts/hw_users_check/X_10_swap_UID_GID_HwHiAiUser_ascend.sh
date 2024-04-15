#!/bin/bash

# Script to swap UID and GID between users 'ascend' and 'HwHiAiUser'

# Function to find the first available UID and GID
find_free_id() {
    local id=1000
    while true; do
        if ! getent passwd $id && ! getent group $id; then
            echo $id
            return
        fi
        id=$((id + 1))
    done
}

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

# Find a free UID and GID to use as temporary
temp_id=$(find_free_id)
echo "temp_id:"
echo $temp_id
exit 0

# Get current UIDs and GIDs
uid_ascend=$(id -u ascend)
gid_ascend=$(id -g ascend)
uid_hw=$(id -u HwHiAiUser)
gid_hw=$(id -g HwHiAiUser)

# Swap UIDs and GIDs using a temporary ID
usermod -u $temp_id ascend
groupmod -g $temp_id ascend
usermod -u $uid_ascend HwHiAiUser
groupmod -g $gid_ascend HwHiAiUser
usermod -u $uid_hw ascend
groupmod -g $gid_hw ascend

# Correct the ownership of home directories
chown -R ascend:ascend /home/ascend
chown -R HwHiAiUser:HwHiAiUser /home/HwHiAiUser

# Print the results
echo "UID and GID after swapping:"
echo "ascend: UID=$(id -u ascend), GID=$(id -g ascend)"
echo "HwHiAiUser: UID=$(id -u HwHiAiUser), GID=$(id -g HwHiAiUser)"

