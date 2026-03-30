#!/usr/bin/env bash
set -euo pipefail

PLUGIN="$HOME/.config/nvim/lua/plugins/dadbod-autocmds.lua"

if [[ ! -f "$PLUGIN" ]]; then
  echo "dadbod-autocmds.lua not found, skipping"
  exit 0
fi

echo "removing dadbod-autocmds plugin spec..."
rm "$PLUGIN"
echo "dadbod-autocmds.lua removed"
