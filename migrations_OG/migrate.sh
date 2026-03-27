#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export REPO_DIR
STATE_DIR="$HOME/.local/state/kodev77/omarchy-setup/migrations"
MIGRATIONS_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$STATE_DIR"

red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
blue()   { printf '\033[0;34m%s\033[0m\n' "$*"; }

run_migration() {
  local script="$1"
  local name
  name="$(basename "$script")"

  if [[ -f "$STATE_DIR/$name" ]]; then
    blue "skip  $name (already completed)"
    return 0
  fi

  green "run   $name"
  if bash "$script"; then
    touch "$STATE_DIR/$name"
    green "done  $name"
  else
    red "FAIL  $name"
    echo ""
    read -rp "Continue with remaining scripts? [y/N] " answer
    if [[ "${answer,,}" != "y" ]]; then
      red "Aborted."
      exit 1
    fi
  fi
}

run_feature() {
  local feature_dir="$1"
  local feature_name
  feature_name="$(basename "$feature_dir" | sed 's/^[0-9]*-//')"

  echo ""
  blue "=== $feature_name ==="
  echo ""

  for script in "$feature_dir"/*.sh; do
    [[ "$(basename "$script")" == "migrate.sh" ]] && continue
    run_migration "$script"
  done
}

# Gather feature directories
features=()
for dir in "$MIGRATIONS_DIR"/*/; do
  [ -d "$dir" ] && features+=("$dir")
done

echo ""
blue "=== omarchy-setup migrations ==="
echo ""

echo "  0) Full Migrate (all features)"
for i in "${!features[@]}"; do
  name="$(basename "${features[$i]}" | sed 's/^[0-9]*-//')"
  printf "  %d) %s\n" $((i + 1)) "$name"
done

echo ""
read -rp "Select an option [0]: " choice
choice="${choice:-0}"

if [[ "$choice" == "0" ]]; then
  for feature_dir in "${features[@]}"; do
    run_feature "$feature_dir"
  done
  echo ""
  green "=== All migrations complete ==="
  echo ""
else
  idx=$((choice - 1))
  if [[ $idx -ge 0 && $idx -lt ${#features[@]} ]]; then
    run_feature "${features[$idx]}"
    echo ""
    green "=== Migration complete ==="
    echo ""
  else
    red "Invalid selection."
    exit 1
  fi
fi
