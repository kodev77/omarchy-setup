#!/usr/bin/env bash
set -euo pipefail

PLUGIN="$HOME/.config/nvim/lua/plugins/gitsigns.lua"

if [[ ! -f "$PLUGIN" ]]; then
  echo "gitsigns plugin not found, skipping"
  exit 0
fi

echo "removing gitsigns plugin spec..."
rm "$PLUGIN"
echo "gitsigns plugin removed"
