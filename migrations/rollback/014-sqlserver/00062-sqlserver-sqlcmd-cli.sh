#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f "$HOME/.local/bin/sqlcmd" ]]; then
  echo "sqlcmd not found, skipping"
  exit 0
fi

echo "removing sqlcmd..."
rm "$HOME/.local/bin/sqlcmd"
echo "sqlcmd removed"
