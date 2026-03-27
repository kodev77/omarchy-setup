#!/usr/bin/env bash
# hyprland stacked groupbar for window groups
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/looknfeel.conf" ]]; then
  if ! grep -q 'stacked = true' "$HYPR/looknfeel.conf"; then
    cat >> "$HYPR/looknfeel.conf" << 'EOF'

group {
    groupbar {
        stacked = true
    }
}
EOF
  fi
  echo "  looknfeel.conf: patched"
fi
