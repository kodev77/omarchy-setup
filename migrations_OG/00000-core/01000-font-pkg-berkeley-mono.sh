#!/usr/bin/env bash
# install Berkeley Mono font from local repo if available
set -euo pipefail

FONT_SRC="$HOME/repo/repository1-c/L3/fonts/Berkeley Mono TX-02/TX-02-ZN3QQVKK"
FONT_DST="$HOME/.local/share/fonts"

if fc-list | grep -qi "berkeley mono"; then
  echo "  Berkeley Mono: already installed"
  exit 0
fi

if [[ ! -d "$FONT_SRC" ]]; then
  echo "  Berkeley Mono: SKIPPED (source repo not available)"
  exit 0
fi

mkdir -p "$FONT_DST"
cp "$FONT_SRC"/*.ttf "$FONT_DST/"
fc-cache -f
echo "  Berkeley Mono: installed"
