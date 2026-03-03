#!/usr/bin/env bash
# chrome profile helpers for app groups menu (init and lookup)
set -euo pipefail

MENU="$HOME/.config/omarchy/extensions/menu.sh"
if [[ -f "$MENU" ]] && ! grep -q 'APP_GROUPS_DIR' "$MENU"; then
  echo "Patching omarchy menu with chrome profile helpers..."
  cat >> "$MENU" << 'MENUEOF'

APP_GROUPS_DIR="$HOME/.config/omarchy/app-groups"
CHROME_PROFILES_FILE="$APP_GROUPS_DIR/chrome-profiles.conf"

# Initialize default chrome profiles config if it doesn't exist
_init_chrome_profiles() {
  if [ ! -f "$CHROME_PROFILES_FILE" ]; then
    cat > "$CHROME_PROFILES_FILE" <<'PROFILES'
# Chrome profile mappings: Label|ProfileDirectory
# Find yours in ~/.config/google-chrome/
Personal|Default
Work|Profile 3
PROFILES
  fi
}

# Get Chrome profile directory for a label (e.g. "Work" -> "Profile 3")
_get_chrome_profile_dir() {
  local label="$1"
  _init_chrome_profiles
  grep "^${label}|" "$CHROME_PROFILES_FILE" 2>/dev/null | head -1 | cut -d'|' -f2
}
MENUEOF
  echo "  extensions/menu.sh: chrome helpers patched"
else
  echo "  extensions/menu.sh: SKIPPED (already patched or file not found)"
fi
