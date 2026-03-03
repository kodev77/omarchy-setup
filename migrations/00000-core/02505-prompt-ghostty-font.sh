#!/usr/bin/env bash
# ghostty: swap font to Berkeley Mono if installed
set -euo pipefail

GHOSTTY_CFG="$HOME/.config/ghostty/config"
if [[ -f "$GHOSTTY_CFG" ]]; then
  if fc-list | grep -qi "berkeley mono"; then
    sed -i 's/font-family = JetBrainsMono Nerd Font/font-family = Berkeley Mono/' "$GHOSTTY_CFG"
    echo "  ghostty/config: patched (Berkeley Mono)"
  else
    echo "  ghostty/config: SKIPPED (Berkeley Mono not installed, keeping JetBrainsMono)"
  fi
else
  echo "  ghostty/config: SKIPPED (file not found)"
fi
