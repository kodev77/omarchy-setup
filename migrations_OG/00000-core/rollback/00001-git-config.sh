#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/git/config"

if [[ ! -f "$CONFIG" ]]; then
  echo "  git config: already absent"
  exit 0
fi

# Remove everything between our markers (inclusive)
sed -i '/^# --- BEGIN ko omarchy-setup ---$/,/^# --- END ko omarchy-setup ---$/d' "$CONFIG"

echo "  git config: rollback complete (ko additions removed)"
