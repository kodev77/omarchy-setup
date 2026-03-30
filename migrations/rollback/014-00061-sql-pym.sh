#!/usr/bin/env bash
set -euo pipefail

echo "uninstalling pymssql..."
python3 -m pip uninstall -y pymssql 2>/dev/null || true
echo "pymssql removed"
