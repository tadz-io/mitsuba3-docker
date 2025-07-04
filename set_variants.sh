#!/bin/bash

# Usage: ./set_variants.sh <path_to_file.conf> "value1" "value2" ...
# Example: ./set_variants.sh mitsuba.conf "scalar_rgb" "cuda_ad_rgb"

# 1. Check for configuration file argument
if [ -z "$1" ]; then
    echo "Error: No configuration file specified."
    exit 1
fi

# 2. Assign arguments to variables
CONFIG_FILE="$1"
shift

jq -nf "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"
# 4. Use jq to update the 'enabled' array
joined_args=$(printf '%s\n' "$@" | jq -R . | jq -s .)

# Use jq to replace the enabled array
jq ".enabled = ${joined_args}" "$CONFIG_FILE".tmp > "$CONFIG_FILE"

cat "$CONFIG_FILE"

# 5. Print confirmation message
echo "Successfully updated '$CONFIG_FILE'."
