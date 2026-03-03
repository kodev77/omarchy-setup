#!/usr/bin/env bash
# lazygit config: custom log format with short hash, dim message, and auto decorations
set -euo pipefail

echo "Patching lazygit config..."

mkdir -p "$HOME/.config/lazygit"
cat > "$HOME/.config/lazygit/config.yml" << 'EOF'
git:
  log:
    showWholeGraph: false
  branchLogCmd: "git log --graph --color=always --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(dim white)%s%C(reset)%C(auto)%d%C(reset)' {{branchName}} --"
  allBranchesLogCmds:
    - "git log --graph --all --color=always --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(dim white)%s%C(reset)%C(auto)%d%C(reset)'"
EOF
echo "  lazygit/config.yml: OK"
