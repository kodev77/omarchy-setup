#!/usr/bin/env bash
# walker patches: rpc prefix provider and placeholder text for rpc app group launcher
set -euo pipefail

WALKER="$HOME/.config/walker/config.toml"
if [[ -f "$WALKER" ]]; then
  if ! grep -q 'appgroups_rpc' "$WALKER"; then
    echo "Patching walker config for RPC..."
    sed -i '/^\[placeholders\]/,/^$/{
      /^$/i\
"menus:appgroups_rpc" = { input = " RPC Apps...", list = "No RPC apps. Use Omarchy Menu > App Groups > Manage to add." }
    }' "$WALKER"
  fi

  if ! grep -q 'prefix = "rpc "' "$WALKER"; then
    cat >> "$WALKER" << 'EOF'

[[providers.prefixes]]
prefix = "rpc "
provider = "menus:appgroups_rpc"
EOF
  fi

  echo "  walker/config.toml: RPC patched"
else
  echo "  walker/config.toml: SKIPPED (file not found)"
fi
