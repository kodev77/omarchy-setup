#!/usr/bin/env bash
set -euo pipefail

if ! pacman -Qi azure-functions-core-tools-bin &>/dev/null; then
  echo "azure-functions-core-tools-bin not installed, skipping"
  exit 0
fi

echo "removing azure-functions-core-tools-bin..."
sudo pacman -Rns --noconfirm azure-functions-core-tools-bin
echo "azure-functions-core-tools-bin removed"
