#!/bin/bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <yaml-file>"
  exit 1
fi

yaml_file="$1"

# Check if the file exists
if [ ! -f "$yaml_file" ]; then
  echo "The specified file does not exist: $yaml_file"
  exit 1
fi

# Extract resource type and name using yq
resource_type=$(yq e '.kind' "$yaml_file")
resource_name=$(yq e '.metadata.name' "$yaml_file")

# Determine the label selector using yq
label_selector=$(yq e '.spec.selector.matchLabels | to_entries | map(.key + "=" + .value) | join(",")' "$yaml_file")

# Get pods based on resource type and label selector
pods=$(kubectl get pods -l "$label_selector" -o name)
pod_array=($pods)

# Check if any pods were found
if [ ${#pod_array[@]} -eq 0 ]; then
  echo -e "\033[31mNo pods found for $resource_type named $resource_name.\033[0m"
  exit 1
fi

# Sort pods
IFS=$'\n' sorted_pods=($(sort <<<"${pod_array[*]}"))
unset IFS

# Select the first pod by default or by index if provided
index=${2:-0}

# Check if the index is within the range of available pods
if [ "$index" -ge "${#sorted_pods[@]}" ]; then
  echo -e "\033[31mInvalid index: $index. There are only ${#sorted_pods[@]} pods available.\033[0m"
  exit 1
fi

# Output the selected pod
selected_pod="${sorted_pods[$index]}"
echo "Selected pod: $selected_pod"

# Placeholder for further commands
echo "Further command execution placeholder..."
