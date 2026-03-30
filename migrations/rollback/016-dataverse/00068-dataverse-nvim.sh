#!/usr/bin/env bash
set -euo pipefail

FILE="$HOME/.config/nvim/lua/util/dadbod-tables/dataverse.lua"

if [[ ! -f "$FILE" ]]; then
  echo "dataverse table helpers not found, skipping"
  exit 0
fi

echo "removing dataverse table helpers..."
rm "$FILE"
echo "dataverse table helpers removed"
