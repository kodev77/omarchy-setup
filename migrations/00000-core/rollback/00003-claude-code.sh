#!/usr/bin/env bash
set -euo pipefail

CLAUDE_BIN="$HOME/.local/bin/claude"

if [[ -f "$CLAUDE_BIN" ]]; then
  rm "$CLAUDE_BIN"
  echo "  claude code: removed"
else
  echo "  claude code: already absent"
fi
