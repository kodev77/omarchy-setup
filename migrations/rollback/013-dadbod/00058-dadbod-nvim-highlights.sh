#!/usr/bin/env bash
set -euo pipefail

PLUGIN="$HOME/.config/nvim/lua/plugins/dadbod-highlights.lua"

if [[ ! -f "$PLUGIN" ]]; then
  echo "dadbod-highlights.lua not found, skipping"
  exit 0
fi

echo "removing dadbod-highlights plugin spec..."
rm "$PLUGIN"
echo "dadbod-highlights.lua removed"
