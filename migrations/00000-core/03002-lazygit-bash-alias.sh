#!/usr/bin/env bash
# bashrc: lazygit alias
set -euo pipefail

echo "Appending lazygit alias to bashrc..."

cat >> "$HOME/.bashrc" << 'BASHRC'

alias lg='lazygit'
BASHRC

echo "  bashrc lg alias: OK"
