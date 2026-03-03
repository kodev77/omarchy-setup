#!/usr/bin/env bash
# app group management: remove apps from groups and delete web apps
set -euo pipefail

MENU="$HOME/.config/omarchy/extensions/menu.sh"
if [[ -f "$MENU" ]] && grep -q '_list_desktop_apps' "$MENU" && ! grep -q '_remove_from_group' "$MENU"; then
  echo "Patching omarchy menu with app group management..."
  cat >> "$MENU" << 'MENUEOF'

# Remove an app from a group
_remove_from_group() {
  local group_name="$1"
  local group_file="$APP_GROUPS_DIR/${group_name,,}.txt"

  if [ ! -s "$group_file" ]; then
    notify-send "App Groups" "No apps in $group_name to remove."
    show_manage_groups_menu
    return
  fi

  local options=""
  while IFS='|' read -r label desktop; do
    [ -n "$label" ] && options="${options}${options:+\\n}$label"
  done < "$group_file"

  local choice
  choice=$(menu "Remove from $group_name" "$options")

  if [ -n "$choice" ]; then
    local tmp
    tmp=$(grep -vF "${choice}|" "$group_file")
    echo "$tmp" > "$group_file"
    notify-send "App Groups" "Removed $choice from $group_name"
  fi
  show_manage_groups_menu
}

# Delete a web app (removes desktop file, icon, and from all groups)
_delete_webapp() {
  # Find all Chrome web apps created by our system (have --profile-directory in Exec)
  local app_list=""
  for f in ~/.local/share/applications/*.desktop; do
    [ -f "$f" ] || continue
    if grep -q 'google-chrome-stable --profile-directory' "$f" 2>/dev/null; then
      local name desktop
      name=$(sed -n 's/^Name=//p' "$f" | head -1)
      desktop=$(basename "$f")
      [ -n "$name" ] && app_list="${app_list}${app_list:+\n}$name|$desktop"
    fi
  done

  if [ -z "$app_list" ]; then
    notify-send "App Groups" "No web apps to delete."
    show_manage_groups_menu
    return
  fi

  local options=""
  while IFS='|' read -r label desktop; do
    [ -n "$label" ] && options="${options}${options:+\\n}$label"
  done <<< "$(echo -e "$app_list")"

  local choice
  choice=$(menu "Delete App" "$options")

  if [ -n "$choice" ]; then
    local desktop
    desktop=$(echo -e "$app_list" | grep "^${choice}|" | head -1 | cut -d'|' -f2)

    if [ -n "$desktop" ]; then
      # Remove desktop file
      rm -f "$HOME/.local/share/applications/$desktop"

      # Remove icon
      local app_name="${desktop%.desktop}"
      rm -f "$HOME/.local/share/applications/icons/$app_name.png"

      # Remove from all group files
      for group_file in "$APP_GROUPS_DIR"/*.txt; do
        [ -f "$group_file" ] || continue
        local tmp
        tmp=$(grep -vF "|$desktop" "$group_file" 2>/dev/null)
        echo "$tmp" > "$group_file"
      done

      notify-send "App Groups" "Deleted $choice"
    fi
  fi
  show_manage_groups_menu
}
MENUEOF
  echo "  extensions/menu.sh: app group management patched"
else
  echo "  extensions/menu.sh: SKIPPED (already patched or not ready)"
fi
