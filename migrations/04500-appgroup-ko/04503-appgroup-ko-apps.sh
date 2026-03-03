#!/usr/bin/env bash
# personal desktop apps and icons: chrome personal, budget, gmail, chase, youtube, espn, yahoo
set -euo pipefail

APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$APPS_DIR/icons"
mkdir -p "$ICONS_DIR"

echo "Copying KO icons..."
cp "$REPO_DIR/icons/ko/"*.png "$ICONS_DIR/"

echo "Copying KO desktop files..."
for f in google-chrome-personal.desktop Budget.desktop Gmail.desktop Chase.desktop YouTube.desktop "ESPN Fantasy.desktop" "Yahoo Fantasy.desktop"; do
  cp "$REPO_DIR/files/local/share/applications/$f" "$APPS_DIR/"
  echo "  $f: OK"
done
