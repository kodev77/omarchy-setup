#!/usr/bin/env bash
set -euo pipefail

MIGRATIONS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$(cd "$MIGRATIONS_DIR/.." && pwd)"
export REPO_DIR MIGRATIONS_DIR

STATE_DIR="$HOME/.local/state/kodev77/omarchy-setup/migrations"

red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
blue()  { printf '\033[0;34m%s\033[0m\n' "$*"; }

is_migrated() {
  local group="$1" name="$2"
  [[ -f "$STATE_DIR/${group}__${name}" ]]
}

unmark_migrated() {
  local group="$1" name="$2"
  rm -f "$STATE_DIR/${group}__${name}"
}

rollback_group() {
  local group_name="$1"
  local rollback_dir="$MIGRATIONS_DIR/rollback/$group_name"

  if [ ! -d "$rollback_dir" ]; then
    red "no rollback scripts found for $group_name"
    return 1
  fi

  local any_rolled_back=false
  local header_shown=false

  # reverse order so last migrated script rolls back first
  local scripts=()
  for script in "$rollback_dir"/*.sh; do
    [ -f "$script" ] && scripts+=("$script")
  done

  for (( i=${#scripts[@]}-1; i>=0; i-- )); do
    local script="${scripts[$i]}"
    local name
    name="$(basename "$script")"

    if ! is_migrated "$group_name" "$name"; then
      continue
    fi

    if ! $header_shown; then
      green "rollback $group_name"
      header_shown=true
    fi

    any_rolled_back=true
    echo "$name"
    echo ""
    if ! bash "$script"; then
      echo ""
      red "fail $name"
      echo ""
      read -rp "continue with remaining rollbacks? [y/N] " answer
      echo ""
      if [[ "${answer,,}" != "y" ]]; then
        red "aborted."
        exit 1
      fi
      continue
    fi

    unmark_migrated "$group_name" "$name"
  done

  if $any_rolled_back; then
    echo ""
    green "done rollback $group_name"
  else
    blue "skip $group_name (not migrated)"
  fi
}

# gather all rollback groups
groups=()
for dir in "$MIGRATIONS_DIR"/rollback/[0-9]*/; do
  [ -d "$dir" ] || continue
  groups+=("$(basename "$dir")")
done

if [[ ${#groups[@]} -eq 0 ]]; then
  blue "nothing to roll back."
  exit 0
fi

# reverse so most recent group rolls back first
reversed=()
for (( i=${#groups[@]}-1; i>=0; i-- )); do
  reversed+=("${groups[$i]}")
done

is_group_migrated() {
  local group_name="$1"
  local rollback_dir="$MIGRATIONS_DIR/rollback/$group_name"
  for script in "$rollback_dir"/*.sh; do
    [ -f "$script" ] || continue
    is_migrated "$group_name" "$(basename "$script")" && return 0
  done
  return 1
}

# build fzf list: all groups + individual scripts (reverse order)
items=()
items+=("[Rollback All]")
for group_name in "${reversed[@]}"; do
  if is_group_migrated "$group_name"; then
    items+=("<$group_name>")
  else
    items+=("<$group_name> \033[0;34m(not migrated)\033[0m")
  fi
  rollback_dir="$MIGRATIONS_DIR/rollback/$group_name"
  # list scripts in reverse
  scripts=()
  for script in "$rollback_dir"/*.sh; do
    [ -f "$script" ] && scripts+=("$script")
  done
  for (( i=${#scripts[@]}-1; i>=0; i-- )); do
    name="$(basename "${scripts[$i]}")"
    if is_migrated "$group_name" "$name"; then
      items+=("  $name")
    else
      items+=("  $name \033[0;34m(not migrated)\033[0m")
    fi
  done
done

selection=$(printf '%b\n' "${items[@]}" | fzf --ansi --prompt="rollback > " --height=~20 --reverse --no-info) || { blue "cancelled."; exit 0; }

# strip ansi codes and status suffix
selection=$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')
selection="${selection% (not migrated)}"
selection="${selection#<}"; selection="${selection%>}"
# strip leading whitespace
selection="${selection#"${selection%%[![:space:]]*}"}"

if [[ "$selection" == "[Rollback All]" ]]; then
  if ! sudo -n true 2>/dev/null; then
    sudo -v
  fi
  for group_name in "${reversed[@]}"; do
    rollback_group "$group_name"
  done
  green "full rollback complete"
  echo ""
  choice=$(printf 'yes\nno' | walker -d -p "reboot now to apply changes?" 2>/dev/null) || choice="no"
  if [[ "$choice" == "yes" ]]; then
    systemctl reboot
  else
    blue "reboot to apply changes"
  fi
elif [[ "$selection" == *.sh ]]; then
  # single script rollback
  found=""
  found_group=""
  for group_name in "${reversed[@]}"; do
    rollback_dir="$MIGRATIONS_DIR/rollback/$group_name"
    if [ -f "$rollback_dir/$selection" ]; then
      found="$rollback_dir/$selection"
      found_group="$group_name"
      break
    fi
  done

  if [[ -z "$found" ]]; then
    red "rollback script not found: $selection"
    exit 1
  fi

  if ! is_migrated "$found_group" "$selection"; then
    blue "skip $selection (not migrated)"
  else
    echo "$selection"
    echo ""
    if bash "$found"; then
      unmark_migrated "$found_group" "$selection"
      echo ""
      green "done rollback $selection"
    else
      echo ""
      red "fail $selection"
      exit 1
    fi
  fi
else
  # group
  rollback_group "$selection"
  green "rollback complete"
fi
