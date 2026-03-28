#!/usr/bin/env bash
# hyprland idle: 15-min screensaver, disable auto-lock and dpms
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/hypridle.conf" ]]; then
  # Screensaver timeout 150 → 900
  sed -i 's/timeout = 150 /timeout = 900 /' "$HYPR/hypridle.conf"
  sed -i 's/# 2\.5min/# 15min/' "$HYPR/hypridle.conf"

  # Comment out the lock listener
  sed -i '/^listener {/{
    N; /timeout = 151/{ s/^listener {/# listener {/; s/\n    timeout/\n#     timeout/; }
  }' "$HYPR/hypridle.conf"
  sed -i 's/^    on-timeout = loginctl lock-session/#     on-timeout = loginctl lock-session/' "$HYPR/hypridle.conf"
  sed -i '/^}$/{ N; }' "$HYPR/hypridle.conf"

  # Comment out the dpms listener
  sed -i 's/^listener {$/# listener {/' "$HYPR/hypridle.conf"
  sed -i 's/^    timeout = 330/#     timeout = 330/' "$HYPR/hypridle.conf"
  sed -i 's/^    on-timeout = hyprctl dispatch dpms off/#     on-timeout = hyprctl dispatch dpms off/' "$HYPR/hypridle.conf"
  sed -i 's/^    on-resume = hyprctl dispatch dpms on/#     on-resume = hyprctl dispatch dpms on/' "$HYPR/hypridle.conf"

  echo "  hypridle.conf: patched"
fi
