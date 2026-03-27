#!/usr/bin/env bash
# rpc app group config listing work desktop apps for the omarchy menu launcher
set -euo pipefail

echo "Copying RPC app group..."
mkdir -p "$HOME/.config/omarchy/app-groups"
cp "$REPO_DIR/files/config/omarchy/app-groups/rpc.txt" "$HOME/.config/omarchy/app-groups/"
echo "  app-groups/rpc.txt: OK"
