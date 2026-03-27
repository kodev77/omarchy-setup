#!/usr/bin/env bash
# install claude code cli
set -euo pipefail

if command -v claude &>/dev/null; then
  echo "  claude code: already installed ($(claude --version 2>/dev/null || echo 'unknown'))"
else
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  echo "  claude code: OK"
fi
