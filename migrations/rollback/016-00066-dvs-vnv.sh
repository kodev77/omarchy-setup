#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="$HOME/.local/share/dvquery-venv"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "dvquery venv not found, skipping"
  exit 0
fi

echo "removing dvquery venv..."
rm -rf "$VENV_DIR"
echo "dvquery venv removed"
