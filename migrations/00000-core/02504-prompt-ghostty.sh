#!/usr/bin/env bash
# ghostty patches: font size 13, blinking cursor, custom cursor color, theme load order
set -euo pipefail

echo "Patching ghostty config..."

GHOSTTY="$HOME/.config/ghostty/config"
if [[ -f "$GHOSTTY" ]]; then
  # font-size 9 → 13
  sed -i 's/^font-size = 9$/font-size = 13/' "$GHOSTTY"

  # cursor-style-blink false → true
  sed -i 's/^cursor-style-blink = false$/cursor-style-blink = true/' "$GHOSTTY"

  # Move theme config-file to end (remove from top, append at bottom)
  if head -3 "$GHOSTTY" | grep -q 'config-file.*ghostty.conf'; then
    sed -i '/^# Dynamic theme colors$/d; /^config-file = ?"~\/.config\/omarchy\/current\/theme\/ghostty.conf"$/d' "$GHOSTTY"
    # Remove leading blank lines left behind
    sed -i '1{/^$/d}' "$GHOSTTY"
  fi

  # Add cursor-color and theme at end if not already there
  if ! grep -q 'cursor-color' "$GHOSTTY"; then
    cat >> "$GHOSTTY" << 'EOF'

# Dynamic theme colors (loaded last so user settings above take priority)
config-file = ?"~/.config/omarchy/current/theme/ghostty.conf"

# Override theme cursor color
cursor-color = #D7C995
EOF
  fi
  echo "  ghostty/config: patched"
else
  echo "  ghostty/config: SKIPPED (file not found)"
fi
