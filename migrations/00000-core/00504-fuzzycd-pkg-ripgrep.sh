#!/usr/bin/env bash
# fast recursive grep that respects .gitignore and searches file contents
set -euo pipefail

yay -S --needed --noconfirm ripgrep
echo "  ripgrep: OK"
