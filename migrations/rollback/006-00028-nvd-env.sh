#!/usr/bin/env bash
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ ! -f "$HYPR/envs.conf" ]] || ! grep -q '# --- BEGIN ko omarchy-setup nvidia ---' "$HYPR/envs.conf"; then
  echo "NVIDIA env not configured, skipping"
  exit 0
fi

echo "reverting NVIDIA env..."
sed -i '/# --- BEGIN ko omarchy-setup nvidia ---/,/# --- END ko omarchy-setup nvidia ---/d' "$HYPR/envs.conf"
echo "envs.conf reverted"
