#!/usr/bin/env bash
# ko app group config listing personal desktop apps for the omarchy menu launcher
set -euo pipefail

echo "Copying KO app group..."
mkdir -p "$HOME/.config/omarchy/app-groups"
cp "$REPO_DIR/files/config/omarchy/app-groups/ko.txt" "$HOME/.config/omarchy/app-groups/"
echo "  app-groups/ko.txt: OK"
