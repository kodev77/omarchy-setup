#!/usr/bin/env bash
# terminal ui for git with staging, branching, rebasing, and conflict resolution
set -euo pipefail

sudo pacman -S --needed --noconfirm lazygit
echo "  lazygit: OK"
