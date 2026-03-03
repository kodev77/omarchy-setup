#!/usr/bin/env bash
# hyprland resize keybindings: Super+Ctrl+arrows
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/bindings.conf" ]]; then
  if ! grep -q 'Resize left' "$HYPR/bindings.conf"; then
    cat >> "$HYPR/bindings.conf" << 'EOF'

# Resize windows
bindd = SUPER CTRL, left, Resize left, resizeactive, -40 0
bindd = SUPER CTRL, right, Resize right, resizeactive, 40 0
bindd = SUPER CTRL, up, Resize up, resizeactive, 0 -40
bindd = SUPER CTRL, down, Resize down, resizeactive, 0 40

# Overwrite existing bindings, like putting Omarchy Menu on Super + Space
# unbind = SUPER, SPACE
# bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu
EOF
  fi
  echo "  bindings.conf: patched"
fi
