#!/usr/bin/env bash
# tool for building interactive shell scripts with prompts, spinners, and styled text
set -euo pipefail

sudo pacman -S --needed --noconfirm gum
echo "  gum: OK"
