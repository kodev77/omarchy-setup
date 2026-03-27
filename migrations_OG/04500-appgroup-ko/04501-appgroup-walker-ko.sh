#!/usr/bin/env bash
# walker patches: ko prefix provider and placeholder text for ko app group launcher
set -euo pipefail

WALKER="$HOME/.config/walker/config.toml"
if [[ -f "$WALKER" ]]; then
  if ! grep -q 'appgroups_ko' "$WALKER"; then
    echo "Patching walker config for KO..."
    sed -i '/^\[placeholders\]/,/^$/{
      /^$/i\
"menus:appgroups_ko" = { input = " KO Apps...", list = "No KO apps. Use Omarchy Menu > App Groups > Manage to add." }
    }' "$WALKER"
  fi

  if ! grep -q 'prefix = "ko "' "$WALKER"; then
    cat >> "$WALKER" << 'EOF'

[[providers.prefixes]]
prefix = "ko "
provider = "menus:appgroups_ko"
EOF
  fi

  echo "  walker/config.toml: KO patched"
else
  echo "  walker/config.toml: SKIPPED (file not found)"
fi
