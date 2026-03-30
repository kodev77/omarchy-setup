#!/usr/bin/env bash
set -euo pipefail

if ! pacman -Qi azure-cli &>/dev/null; then
  echo "azure-cli not installed, skipping"
  exit 0
fi

echo "removing azure-cli..."
sudo pacman -Rns --noconfirm azure-cli
echo "azure-cli removed"
