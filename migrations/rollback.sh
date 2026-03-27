#!/usr/bin/env bash
set -euo pipefail

MIGRATIONS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$MIGRATIONS_DIR/.." && pwd)"
export REPO_DIR MIGRATIONS_DIR

STATE_DIR="$HOME/.local/state/kodev77/omarchy-setup/migrations"

red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
blue()  { printf '\033[0;34m%s\033[0m\n' "$*"; }

is_migrated() {
  [[ -f "$STATE_DIR/$1" ]]
}

unmark_migrated() {
  rm -f "$STATE_DIR/$1"
}

rollback_group() {
  local group_name="$1"
  local rollback_dir="$MIGRATIONS_DIR/rollback/$group_name"

  if [ ! -d "$rollback_dir" ]; then
    red "no rollback scripts found for $group_name"
    return 1
  fi

  local any_rolled_back=false

  green "rollback $group_name"

  # reverse order so last migrated script rolls back first
  local scripts=()
  for script in "$rollback_dir"/*.sh; do
    [ -f "$script" ] && scripts+=("$script")
  done

  for (( i=${#scripts[@]}-1; i>=0; i-- )); do
    local script="${scripts[$i]}"
    local name
    name="$(basename "$script")"

    if ! is_migrated "$name"; then
      blue "skip $name (not migrated)"
      continue
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

    unmark_migrated "$name"
  done

  if $any_rolled_back; then
    echo ""
    green "done rollback $group_name"
  else
    blue "skip $group_name (not migrated)"
  fi
}

# gather groups that have migrated scripts
groups=()
for dir in "$MIGRATIONS_DIR"/rollback/[0-9]*/; do
  [ -d "$dir" ] || continue
  local_name="$(basename "$dir")"
  for script in "$dir"/*.sh; do
    [ -f "$script" ] && is_migrated "$(basename "$script")" && { groups+=("$local_name"); break; }
  done
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

echo ""
blue "rollback"
echo ""

echo "0) all groups (reverse order)"
for i in "${!reversed[@]}"; do
  printf "%d) %s\n" $((i + 1)) "${reversed[$i]}"
done

echo ""
read -rp "select an option [0]: " choice
echo ""
choice="${choice:-0}"

if [[ "$choice" == "0" ]]; then
  for group_name in "${reversed[@]}"; do
    rollback_group "$group_name"
  done
  green "full rollback complete"
  echo ""
else
  idx=$((choice - 1))
  if [[ $idx -ge 0 && $idx -lt ${#reversed[@]} ]]; then
    rollback_group "${reversed[$idx]}"
    green "rollback complete"
    echo ""
  else
    red "invalid selection."
    exit 1
  fi
fi
