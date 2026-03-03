#!/usr/bin/env bash
# general-purpose fuzzy finder for filtering lists, files, and command output interactively
set -euo pipefail

yay -S --needed --noconfirm fzf
echo "  fzf: OK"
