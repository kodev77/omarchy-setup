#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"

if [[ ! -f "$BASHRC" ]]; then
  echo "  bashrc: already absent"
  exit 0
fi

# Remove everything between our markers (inclusive)
sed -i '/^# --- BEGIN ko omarchy-setup fuzzycd ---$/,/^# --- END ko omarchy-setup fuzzycd ---$/d' "$BASHRC"

echo "  bashrc fuzzycd functions: rollback complete"
