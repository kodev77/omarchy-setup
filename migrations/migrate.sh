#!/usr/bin/env bash
set -euo pipefail

MIGRATIONS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$MIGRATIONS_DIR/.." && pwd)"
export REPO_DIR MIGRATIONS_DIR

STATE_DIR="$HOME/.local/state/kodev77/omarchy-setup/migrations"
mkdir -p "$STATE_DIR"

red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
blue()  { printf '\033[0;34m%s\033[0m\n' "$*"; }

is_migrated() {
  local group="$1" name="$2"
  [[ -f "$STATE_DIR/${group}__${name}" ]]
}

mark_migrated() {
  local group="$1" name="$2"
  touch "$STATE_DIR/${group}__${name}"
}

is_group_done() {
  local dir="$1"
  local group_name
  group_name="$(basename "$dir")"
  for script in "$dir"/*.sh; do
    [ -f "$script" ] || continue
    is_migrated "$group_name" "$(basename "$script")" || return 1
  done
  return 0
}

run_group() {
  local group_dir="$1"
  local group_name
  group_name="$(basename "$group_dir")"
  local all_done=true
  local header_shown=false

  for script in "$group_dir"/*.sh; do
    [ -f "$script" ] || continue
    local name
    name="$(basename "$script")"

    if is_migrated "$group_name" "$name"; then
      continue
    fi

    if ! $header_shown; then
      green "run $group_name"
      header_shown=true
    fi

    all_done=false
    echo "$name"
    echo ""
    local rc=0
    bash "$script" || rc=$?
    if [[ $rc -eq 2 ]]; then
      # script skipped (e.g. missing dependency)
      continue
    elif [[ $rc -ne 0 ]]; then
      echo ""
      red "fail $name"
      echo ""
      read -rp "continue with remaining scripts? [y/N] " answer
      echo ""
      if [[ "${answer,,}" != "y" ]]; then
        red "aborted."
        exit 1
      fi
      continue
    fi

    mark_migrated "$group_name" "$name"
  done

  if $all_done; then
    blue "skip $group_name (already migrated)"
  else
    echo ""
    green "done $group_name"
  fi
}

# gather migration groups (numbered directories, exclude rollback)
groups=()
for dir in "$MIGRATIONS_DIR"/[0-9]*/; do
  [ -d "$dir" ] && groups+=("$dir")
done

if [[ ${#groups[@]} -eq 0 ]]; then
  blue "no migration groups found."
  exit 0
fi

# build fzf list: rollback, all groups + individual scripts
items=()
items+=("[Rollback]")
items+=("[Migrate All]")
for dir in "${groups[@]}"; do
  group_name="$(basename "$dir")"
  if is_group_done "$dir"; then
    items+=("<$group_name> \033[0;32m(done)\033[0m")
  else
    items+=("<$group_name>")
  fi
  for script in "$dir"/*.sh; do
    [ -f "$script" ] || continue
    name="$(basename "$script")"
    if is_migrated "$group_name" "$name"; then
      items+=("  $name \033[0;32m(done)\033[0m")
    else
      items+=("  $name")
    fi
  done
done

selection=$(printf '%b\n' "${items[@]}" | fzf --ansi --prompt="migrate > " --height=~20 --reverse --no-info) || { blue "cancelled."; exit 0; }

# strip ansi codes and status suffix
selection=$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')
selection="${selection% (done)}"
selection="${selection#<}"; selection="${selection%>}"
# strip leading whitespace
selection="${selection#"${selection%%[![:space:]]*}"}"

if [[ "$selection" == "[Rollback]" ]]; then
  exec bash "$MIGRATIONS_DIR/rollback/rollback.sh"
elif [[ "$selection" == "[Migrate All]" ]]; then
  # prompt for sudo upfront so scripts don't pause mid-run
  if ! sudo -n true 2>/dev/null; then
    sudo -v
  fi
  for group_dir in "${groups[@]}"; do
    run_group "$group_dir"
  done
  green "all migrations complete"
  echo ""
  choice=$(printf 'yes\nno' | walker -d -p "reboot now to apply changes?" 2>/dev/null) || choice="no"
  if [[ "$choice" == "yes" ]]; then
    systemctl reboot
  else
    blue "reboot to apply changes"
  fi
elif [[ "$selection" == *.sh ]]; then
  # single script
  found=""
  found_group=""
  for dir in "${groups[@]}"; do
    if [ -f "$dir/$selection" ]; then
      found="$dir/$selection"
      found_group="$(basename "$dir")"
      break
    fi
  done

  if [[ -z "$found" ]]; then
    red "script not found: $selection"
    exit 1
  fi

  if is_migrated "$found_group" "$selection"; then
    blue "skip $selection (already migrated)"
  else
    echo "$selection"
    echo ""
    rc=0
    bash "$found" || rc=$?
    if [[ $rc -eq 2 ]]; then
      blue "skip $selection (dependency not available)"
    elif [[ $rc -eq 0 ]]; then
      mark_migrated "$found_group" "$selection"
      echo ""
      green "done $selection"
    else
      echo ""
      red "fail $selection"
      exit 1
    fi
  fi
else
  # group
  for dir in "${groups[@]}"; do
    if [[ "$(basename "$dir")" == "$selection" ]]; then
      run_group "$dir"
      green "migration complete"
      break
    fi
  done
fi
