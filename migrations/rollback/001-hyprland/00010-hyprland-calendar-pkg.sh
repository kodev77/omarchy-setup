#!/usr/bin/env bash
# rollback terminal calendar app
set -euo pipefail

if pacman -Qi lvsk-calendar &>/dev/null; then
  echo "removing lvsk-calendar..."
  sudo pacman -Rns --noconfirm lvsk-calendar
  echo "lvsk-calendar removed"
else
  echo "lvsk-calendar not installed, skipping"
fi
