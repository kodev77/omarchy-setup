#!/usr/bin/env bash
set -euo pipefail

PLUGIN="$HOME/.config/nvim/lua/plugins/dadbod-blink.lua"

if [[ ! -f "$PLUGIN" ]]; then
  echo "dadbod-blink.lua not found, skipping"
  exit 0
fi

echo "removing dadbod-blink plugin spec..."
rm "$PLUGIN"
echo "dadbod-blink.lua removed"
