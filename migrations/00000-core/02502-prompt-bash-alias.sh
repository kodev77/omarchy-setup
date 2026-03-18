#!/usr/bin/env bash
# bashrc: PATH and ll alias
set -euo pipefail

echo "Appending PATH and ll alias to bashrc..."

cat >> "$HOME/.bashrc" << 'BASHRC'

export PATH="$HOME/.local/bin:$PATH"
alias ll='lsa'
BASHRC

echo "  bashrc PATH + ll: OK"
