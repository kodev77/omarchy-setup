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
  [[ -f "$STATE_DIR/$1" ]]
}

mark_migrated() {
  touch "$STATE_DIR/$1"
}

run_group() {
  local group_dir="$1"
  local group_name
  group_name="$(basename "$group_dir")"
  local all_done=true

  for script in "$group_dir"/*.sh; do
    [ -f "$script" ] || continue
    local name
    name="$(basename "$script")"

    if is_migrated "$name"; then
      blue "skip $name (already migrated)"
      continue
    fi

    all_done=false
    echo "$name"
    echo ""
    if ! bash "$script"; then
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

    mark_migrated "$name"
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

echo ""
blue "migrate"
echo ""

is_group_done() {
  local dir="$1"
  for script in "$dir"/*.sh; do
    [ -f "$script" ] || continue
    is_migrated "$(basename "$script")" || return 1
  done
  return 0
}

echo "0) all groups"
for i in "${!groups[@]}"; do
  name="$(basename "${groups[$i]}")"
  if is_group_done "${groups[$i]}"; then
    printf "%d) %s (done)\n" $((i + 1)) "$name"
  else
    printf "%d) %s\n" $((i + 1)) "$name"
  fi
done

echo ""
read -rp "select an option [0]: " choice
echo ""
choice="${choice:-0}"

if [[ "$choice" == "0" ]]; then
  for group_dir in "${groups[@]}"; do
    run_group "$group_dir"
  done
  green "all migrations complete"
  echo ""
else
  idx=$((choice - 1))
  if [[ $idx -ge 0 && $idx -lt ${#groups[@]} ]]; then
    run_group "${groups[$idx]}"
    green "migration complete"
    echo ""
  else
    red "invalid selection."
    exit 1
  fi
fi
