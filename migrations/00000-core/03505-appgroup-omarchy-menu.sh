#!/usr/bin/env bash
# app group menus: dynamic group discovery and main menu override with app groups entry
set -euo pipefail

MENU="$HOME/.config/omarchy/extensions/menu.sh"
if [[ -f "$MENU" ]] && grep -q '_remove_from_group' "$MENU" && ! grep -q 'show_app_groups_menu' "$MENU"; then
  echo "Patching omarchy menu with app group menus..."
  cat >> "$MENU" << 'MENUEOF'

_manage_single_group() {
  local group_name="$1"
  case $(menu "Manage $group_name" "󰐕  Create Web App\n󰐕  Add Existing App\n󰍴  Remove App") in
  *"Create Web App"*) _create_webapp_for_group "$group_name" ;;
  *"Add Existing"*) _add_existing_to_group "$group_name" ;;
  *"Remove App"*) _remove_from_group "$group_name" ;;
  *) back_to show_manage_groups_menu ;;
  esac
}

show_manage_groups_menu() {
  local options=""
  for group_file in "$APP_GROUPS_DIR"/*.txt; do
    [ -f "$group_file" ] || continue
    local name
    name=$(basename "$group_file" .txt)
    options="${options}${options:+\\n}  ${name^^}"
  done
  options="${options}${options:+\\n}󰩺  Delete App"

  local choice
  choice=$(menu "Manage Groups" "$options")

  case "${choice,,}" in
  *"delete app"*) _delete_webapp ;;
  "") back_to show_app_groups_menu ;;
  *)
    local group_name
    group_name=$(echo "$choice" | sed 's/^[^ ]* *//')
    _manage_single_group "$group_name"
    ;;
  esac
}

show_app_groups_menu() {
  local options=""
  for group_file in "$APP_GROUPS_DIR"/*.txt; do
    [ -f "$group_file" ] || continue
    local name
    name=$(basename "$group_file" .txt)
    options="${options}${options:+\\n}  ${name^^}"
  done
  options="${options}${options:+\\n}󰒓  Manage"

  local choice
  choice=$(menu "App Groups" "$options")

  case "${choice,,}" in
  *manage*) show_manage_groups_menu ;;
  "") show_main_menu ;;
  *)
    local group_name
    group_name=$(echo "$choice" | sed 's/^[^ ]* *//')
    _show_group_apps "$group_name"
    ;;
  esac
}

# Override main menu to add App Groups entry
show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n  App Groups\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System")"
}

# Override go_to_menu to handle the new entry
go_to_menu() {
  case "${1,,}" in
  *"app groups"*) show_app_groups_menu ;;
  *apps*) walker -p "Launch..." ;;
  *learn*) show_learn_menu ;;
  *trigger*) show_trigger_menu ;;
  *share*) show_share_menu ;;
  *style*) show_style_menu ;;
  *theme*) show_theme_menu ;;
  *screenshot*) show_screenshot_menu ;;
  *screenrecord*) show_screenrecord_menu ;;
  *setup*) show_setup_menu ;;
  *power*) show_setup_power_menu ;;
  *install*) show_install_menu ;;
  *remove*) show_remove_menu ;;
  *update*) show_update_menu ;;
  *about*) omarchy-launch-about ;;
  *system*) show_system_menu ;;
  esac
}
MENUEOF
  echo "  extensions/menu.sh: app group menus patched"
else
  echo "  extensions/menu.sh: SKIPPED (already patched or not ready)"
fi
