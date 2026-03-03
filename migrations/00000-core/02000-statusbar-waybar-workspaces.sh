#!/usr/bin/env bash
# waybar: add persistent workspaces 6-10
set -euo pipefail

WAYBAR_CFG="$HOME/.config/waybar/config.jsonc"
if [[ -f "$WAYBAR_CFG" ]]; then
  if ! grep -q '"6": \[\]' "$WAYBAR_CFG"; then
    sed -i '/"5": \[\]/s/}$/},/' "$WAYBAR_CFG"
    sed -i '/"5": \[\]/a\      "6": [],\n      "7": [],\n      "8": [],\n      "9": [],\n      "10": []' "$WAYBAR_CFG"
  fi
  echo "  waybar/config.jsonc: workspaces 6-10 patched"
else
  echo "  waybar/config.jsonc: SKIPPED (file not found)"
fi
