#!/usr/bin/env bash
# .net sdk for building and running c# applications and web apis
set -euo pipefail

yay -S --needed --noconfirm dotnet-sdk
echo "  dotnet-sdk: OK"
