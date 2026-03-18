#!/usr/bin/env bash
# waybar: bar height, berkeley mono font, bold styling
set -euo pipefail

# --- waybar/config.jsonc: bar height ---
WAYBAR_CFG="$HOME/.config/waybar/config.jsonc"
if [[ -f "$WAYBAR_CFG" ]]; then
  sed -i 's/"height": 26/"height": 32/' "$WAYBAR_CFG"
  echo "  waybar/config.jsonc: height patched"
else
  echo "  waybar/config.jsonc: SKIPPED (file not found)"
fi

# --- waybar/style.css: font and bold ---
WAYBAR_CSS="$HOME/.config/waybar/style.css"
if [[ -f "$WAYBAR_CSS" ]]; then
  # Font family (only swap if Berkeley Mono is installed)
  if fc-list | grep -qi "berkeley mono"; then
    sed -i "s/font-family: 'JetBrainsMono Nerd Font';/font-family: 'Berkeley Mono';/" "$WAYBAR_CSS"
  else
    echo "  waybar/style.css: SKIPPED font swap (Berkeley Mono not installed, keeping JetBrainsMono)"
  fi

  # Font size
  sed -i 's/font-size: 12px;/font-size: 11pt;/' "$WAYBAR_CSS"

  # Add workspace font-weight normal + bold rules if missing
  if ! grep -q 'font-weight: normal' "$WAYBAR_CSS"; then
    sed -i '/#workspaces button {/,/}/{
      /min-width:/a\  font-weight: normal;
    }' "$WAYBAR_CSS"
  fi

  if ! grep -q 'button:not(.empty)' "$WAYBAR_CSS"; then
    sed -i '/#workspaces button.empty {/i\#workspaces button:not(.empty) {\n  font-weight: bold;\n}\n' "$WAYBAR_CSS"
  fi

  # Clock font-weight bold
  if ! grep -q '#clock' "$WAYBAR_CSS" || ! sed -n '/#clock/,/}/p' "$WAYBAR_CSS" | grep -q 'font-weight: bold'; then
    sed -i '/#clock {/a\  font-weight: bold;' "$WAYBAR_CSS"
  fi

  echo "  waybar/style.css: patched"
else
  echo "  waybar/style.css: SKIPPED (file not found)"
fi
