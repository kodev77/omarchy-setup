#!/usr/bin/env bash
# hyprland window rule for calendar app sizing
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/hyprland.conf" ]]; then
  if ! grep -q 'lvsk-calendar' "$HYPR/hyprland.conf"; then
    echo 'windowrule = size 1200 700, match:title ^lvsk-calendar$' >> "$HYPR/hyprland.conf"
  fi
  echo "  hyprland.conf: patched"
fi
