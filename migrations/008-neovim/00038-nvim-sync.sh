#!/usr/bin/env bash
# sync neovim plugins, treesitter parsers, and mason tools
set -euo pipefail

echo "syncing neovim plugins..."
nvim --headless -c "Lazy install" -c "sleep 5" -c "qa" 2>&1 || true

echo "updating treesitter parsers..."
nvim --headless -c "TSInstall! vim" -c "TSUpdate" -c "sleep 5" -c "qa" 2>&1 || true

echo "updating mason tools..."
nvim --headless -c "lua require('mason-registry').update(function() print('mason registry updated') end)" -c "sleep 5" -c "qa" 2>&1 || true

echo "  neovim sync: OK"

echo ""
echo "restart nvim to apply changes"
