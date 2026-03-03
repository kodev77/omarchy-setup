#!/usr/bin/env bash
# python library for connecting to sql server databases via freetds
set -euo pipefail

pip install --user pymssql
echo "  pymssql: OK"
