#!/usr/bin/env bash
# fast, user-friendly alternative to find for searching files and directories
set -euo pipefail

yay -S --needed --noconfirm fd
echo "  fd: OK"
