#!/usr/bin/env bash
set -euo pipefail

PLUGIN="$HOME/.config/nvim/lua/plugins/dadbod-ui.lua"

if [[ ! -f "$PLUGIN" ]]; then
  echo "dadbod-ui.lua not found, skipping"
  exit 0
fi

echo "removing dadbod-ui plugin spec..."
rm "$PLUGIN"
echo "dadbod-ui.lua removed"
