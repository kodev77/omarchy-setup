#!/usr/bin/env bash
set -euo pipefail

FILE="$HOME/.config/nvim/lua/util/db2.lua"

if [[ ! -f "$FILE" ]]; then
  echo "db2 util not found, skipping"
  exit 0
fi

echo "removing db2 util module..."
rm "$FILE"
echo "db2 util removed"
