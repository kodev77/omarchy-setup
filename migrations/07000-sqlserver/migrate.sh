#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export REPO_DIR
STATE_DIR="$HOME/.local/state/kodev77/omarchy-setup/migrations"

mkdir -p "$STATE_DIR"

red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
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

FEATURE_NAME="$(basename "$SCRIPT_DIR" | sed 's/^[0-9]*-//')"

echo ""
blue "=== $FEATURE_NAME ==="
echo ""

for script in "$SCRIPT_DIR"/*.sh; do
  [[ "$(basename "$script")" == "migrate.sh" ]] && continue
  run_migration "$script"
done

echo ""
green "=== $FEATURE_NAME complete ==="
echo ""
