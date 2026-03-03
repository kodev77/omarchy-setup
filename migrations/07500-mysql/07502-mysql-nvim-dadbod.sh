#!/usr/bin/env bash
# mysql/mariadb table helpers: custom list (limit 200) and count queries for dadbod-ui
set -euo pipefail

NVIM_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_DIR/lua/plugins"

echo "Writing MySQL/MariaDB table helpers..."

cat > "$NVIM_DIR/lua/plugins/dadbod-table-mysql.lua" << 'EOF'
-- MySQL/MariaDB table helpers for dadbod-ui
-- On Arch Linux, mysql is provided by MariaDB (wire-compatible)
-- ROW_COUNT() for modifying queries is handled in util/dadbod-helpers.lua
return {
  "kristijanhusak/vim-dadbod-ui",
  init = function()
    local helpers = vim.g.db_ui_table_helpers or {}
    helpers.mysql = {
      List = "SELECT * FROM `{table}` LIMIT 200",
      Count = "SELECT COUNT(*) FROM `{table}`",
    }
    vim.g.db_ui_table_helpers = helpers
  end,
}
EOF

echo "  plugins/dadbod-table-mysql.lua: OK"
