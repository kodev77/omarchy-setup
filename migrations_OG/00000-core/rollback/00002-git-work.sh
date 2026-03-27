#!/usr/bin/env bash
set -euo pipefail

WORK_CONFIG="$HOME/.gitconfig.work"
if [[ -f "$WORK_CONFIG" ]]; then
  rm "$WORK_CONFIG"
  echo "  gitconfig.work: removed"
else
  echo "  gitconfig.work: already absent"
fi
