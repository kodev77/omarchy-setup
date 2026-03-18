#!/usr/bin/env bash
# terminal calendar app for waybar clock right-click
set -euo pipefail

if ! pacman -Qi lvsk-calendar &>/dev/null; then
  sudo pacman -S --noconfirm lvsk-calendar
fi
echo "  lvsk-calendar: OK"
