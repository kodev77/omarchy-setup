#!/usr/bin/env bash
# dadbod table helpers for dataverse (list, columns, count)
set -euo pipefail

NVIM_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_DIR/lua/plugins"

echo "Writing Dataverse table helpers..."

cat > "$NVIM_DIR/lua/plugins/dadbod-table-dataverse.lua" << 'EOF'
-- Dataverse table helpers for dadbod-ui (used with custom dvquery adapter)
return {
  "kristijanhusak/vim-dadbod-ui",
  init = function()
    local helpers = vim.g.db_ui_table_helpers or {}
    helpers.dataverse = {
      List = "SELECT TOP 200 * FROM {table}",
      Columns = ".columns {table}",
      Count = "SELECT COUNT(*) FROM {table}",
    }
    vim.g.db_ui_table_helpers = helpers
  end,
}
EOF

echo "  plugins/dadbod-table-dataverse.lua: OK"
