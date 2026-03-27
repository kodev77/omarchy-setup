#!/usr/bin/env bash
# work desktop apps and icons: chrome work, teams, outlook, chatgpt, claude, azure, devops, dynamics
set -euo pipefail

APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$APPS_DIR/icons"
mkdir -p "$ICONS_DIR"

echo "Copying RPC icons..."
cp "$REPO_DIR/icons/rpc/"*.png "$ICONS_DIR/"

echo "Copying RPC desktop files..."
for f in google-chrome-work.desktop "Microsoft Teams.desktop" "Microsoft Outlook.desktop" "ChatGPT.desktop" "Claude AI.desktop" "Project Insight.desktop" "Workday RPC.desktop" "Microsoft Azure.desktop" "Microsoft DevOps.desktop" "Dynamics FSA - FS01.desktop" "Dynamics FSA - SIT.desktop" "PowerBI Training - Matrix.desktop" "LMS - RPC Training.desktop"; do
  cp "$REPO_DIR/files/local/share/applications/$f" "$APPS_DIR/"
  echo "  $f: OK"
done
