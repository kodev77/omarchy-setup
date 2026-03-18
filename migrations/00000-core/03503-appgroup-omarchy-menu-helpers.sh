#!/usr/bin/env bash
# app group helpers: list apps, show group, add to group, create webapp
set -euo pipefail

MENU="$HOME/.config/omarchy/extensions/menu.sh"
if [[ -f "$MENU" ]] && grep -q 'APP_GROUPS_DIR' "$MENU" && ! grep -q '_list_desktop_apps' "$MENU"; then
  echo "Patching omarchy menu with app group helpers..."
  cat >> "$MENU" << 'MENUEOF'

# List installed desktop apps as "Name|desktop-file" lines for dmenu selection
_list_desktop_apps() {
  for f in ~/.local/share/applications/*.desktop /usr/share/applications/*.desktop; do
    [ -f "$f" ] || continue
    name=$(sed -n 's/^Name=//p' "$f" | head -1)
    desktop=$(basename "$f")
    [ -n "$name" ] && echo "$name|$desktop"
  done | sort -t'|' -k1,1 -u
}

# Show apps from a group file and launch selected
_show_group_apps() {
  local group_name="$1"
  local group_file="$APP_GROUPS_DIR/${group_name,,}.txt"

  if [ ! -s "$group_file" ]; then
    notify-send "App Groups" "No apps in $group_name yet. Use Manage to add some."
    show_app_groups_menu
    return
  fi

  local options=""
  while IFS='|' read -r label desktop; do
    [ -n "$label" ] && options="${options}${options:+\\n}$label"
  done < "$group_file"

  local choice
  choice=$(menu "$group_name" "$options")

  if [ -n "$choice" ]; then
    local desktop
    desktop=$(grep "^${choice}|" "$group_file" | head -1 | cut -d'|' -f2)
    if [ -n "$desktop" ]; then
      setsid gtk-launch "$desktop" &
    fi
  else
    back_to show_app_groups_menu
  fi
}

# Add an existing installed app to a group
_add_existing_to_group() {
  local group_name="$1"
  local group_file="$APP_GROUPS_DIR/${group_name,,}.txt"

  local all_apps options=""
  all_apps=$(_list_desktop_apps)

  while IFS='|' read -r name desktop; do
    if ! grep -qF "|$desktop" "$group_file" 2>/dev/null; then
      options="${options}${options:+\\n}$name"
    fi
  done <<< "$all_apps"

  local choice
  choice=$(menu "Add to $group_name" "$options" "--width 400 --maxheight 600")

  if [ -n "$choice" ]; then
    local desktop
    desktop=$(echo "$all_apps" | grep "^${choice}|" | head -1 | cut -d'|' -f2)
    if [ -n "$desktop" ]; then
      echo "${choice}|${desktop}" >> "$group_file"
      notify-send "App Groups" "Added $choice to $group_name"
    fi
  fi
  show_manage_groups_menu
}

# Create a new Chrome web app and add it to a group (opens in a terminal)
_create_webapp_for_group() {
  local group_name="$1"
  _init_chrome_profiles
  present_terminal "$HOME/.local/bin/appgroup-create-webapp $group_name"
}
MENUEOF
  echo "  extensions/menu.sh: app group helpers patched"
else
  echo "  extensions/menu.sh: SKIPPED (already patched or not ready)"
fi
