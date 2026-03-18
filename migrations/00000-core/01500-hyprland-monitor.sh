#!/usr/bin/env bash
# hyprland dual monitor setup: HDMI + laptop mirrored, GDK_SCALE fix
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/monitors.conf" ]]; then
  # GDK_SCALE 2 → 1
  sed -i 's/^env = GDK_SCALE,2$/env = GDK_SCALE,1/' "$HYPR/monitors.conf"

  # Replace the default monitor line with our specific setup
  if ! grep -q 'HDMI-A-1' "$HYPR/monitors.conf"; then
    sed -i 's|^monitor=,preferred,auto,auto$|monitor = HDMI-A-1, 2560x1440@60, 0x0, 1\nmonitor = eDP-2, 2560x1600@240, 0x0, 1.6, mirror, HDMI-A-1|' "$HYPR/monitors.conf"
  fi
  echo "  monitors.conf: patched"
fi
