#!/usr/bin/env bash
# dbout highlight groups for borders, headers, types, nulls; re-applied on colorscheme change
set -euo pipefail

NVIM_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_DIR/lua/plugins"

echo "Writing dadbod dbout highlight groups..."

cat > "$NVIM_DIR/lua/plugins/dadbod-highlights.lua" << 'EOF'
-- Dbout highlight groups for formatted database output
-- Re-applies on ColorScheme event since theme changes clear custom highlights
return {
  "kristijanhusak/vim-dadbod-ui",
  init = function()
    local function set_dbout_highlights()
      vim.api.nvim_set_hl(0, "DboutBorder", { link = "Comment" })
      vim.api.nvim_set_hl(0, "DboutHeader", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "DboutString", { link = "String" })
      vim.api.nvim_set_hl(0, "DboutNumber", { link = "Number" })
      vim.api.nvim_set_hl(0, "DboutGuid", { link = "Type" })
      vim.api.nvim_set_hl(0, "DboutTimestamp", { link = "Function" })
      vim.api.nvim_set_hl(0, "DboutTruncated", { link = "Comment" })
      vim.api.nvim_set_hl(0, "DboutNull", { link = "Comment" })
      vim.api.nvim_set_hl(0, "DboutRowCount", { fg = "#838781", italic = true })
    end
    set_dbout_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_dbout_highlights,
    })
  end,
}
EOF

echo "  plugins/dadbod-highlights.lua: OK"
