#!/usr/bin/env bash
# bash nvim cwd hook and cursor styling
set -euo pipefail

echo "Appending nvim hook and cursor styling to bashrc..."

cat >> "$HOME/.bashrc" << 'BASHRC'

# Pick up nvim cwd-on-exit when prompt returns
__nvim_cwd_hook() {
  if [ -f ~/.nvim_cwd ]; then
    local dir
    dir="$(command cat ~/.nvim_cwd)"
    rm -f ~/.nvim_cwd
    [ -n "$dir" ] && [ "$dir" != "$PWD" ] && builtin cd -- "$dir"
  fi
}
# Set blinking block cursor
__set_cursor() { printf '\e[1 q\e]12;#D7C995\a'; }
PROMPT_COMMAND="__nvim_cwd_hook;__set_cursor;${PROMPT_COMMAND}"
BASHRC

echo "  bash nvim hook + cursor: OK"
