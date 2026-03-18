#!/usr/bin/env bash
# hyprland lock screen font swap to Berkeley Mono
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/hyprlock.conf" ]]; then
  if fc-list | grep -qi "berkeley mono"; then
    sed -i 's/font_family = JetBrainsMono Nerd Font/font_family = Berkeley Mono/' "$HYPR/hyprlock.conf"
    echo "  hyprlock.conf: patched (Berkeley Mono)"
  else
    echo "  hyprlock.conf: SKIPPED (Berkeley Mono not installed, keeping JetBrainsMono)"
  fi
fi
