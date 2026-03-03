#!/usr/bin/env bash
# interactive script to create chrome web app shortcuts and add them to app groups
set -euo pipefail

mkdir -p "$HOME/.local/bin"

echo "Copying appgroup-create-webapp..."
cp "$REPO_DIR/files/local/bin/appgroup-create-webapp" "$HOME/.local/bin/appgroup-create-webapp"
chmod +x "$HOME/.local/bin/appgroup-create-webapp"

echo "  appgroup-create-webapp: OK"
