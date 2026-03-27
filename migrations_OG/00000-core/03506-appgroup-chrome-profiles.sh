#!/usr/bin/env bash
# chrome profile mappings (personal/work) used by appgroup-create-webapp for web app shortcuts
set -euo pipefail

echo "Copying Chrome profiles config..."
mkdir -p "$HOME/.config/omarchy/app-groups"
cp "$REPO_DIR/files/config/omarchy/app-groups/chrome-profiles.conf" "$HOME/.config/omarchy/app-groups/"
echo "  app-groups/chrome-profiles.conf: OK"
