#!/usr/bin/env bash

declare -A replacements
declare -a replace_order

# Read replacements from .env file
while IFS='=' read -r placeholder original; do
  # Ignore empty lines or comments
  [[ -z "$placeholder" || "$placeholder" =~ ^# ]] && continue

  # EXAMPLE_PLACEHOLDER -> <example_placeholder>
  placeholder="<$(echo "$placeholder" | tr '[:upper:]' '[:lower:]')>"

  replacements["$original"]="$placeholder"
  replace_order+=("$original")
done < "$PWD/replacements.env"

sed_cmd="sed"

for original in "${replace_order[@]}"; do
  if [[ "$1" == "clean" ]]; then
    sed_cmd+=" -e \"s/${original}/${replacements[${original}]}/g\""
  elif [[ "$1" == "smudge" ]]; then
    sed_cmd+=" -e \"s/${replacements[${original}]}/${original}/g\""
  else
    echo "First argument should be 'clean' or 'smudge'"
    exit 1
  fi
done

eval $sed_cmd
