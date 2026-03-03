#!/usr/bin/env bash
# hyprland env vars: NVIDIA drivers and LibreOffice Wayland fix
set -euo pipefail

HYPR="$HOME/.config/hypr"

if [[ -f "$HYPR/envs.conf" ]]; then
  # Append if not already present
  if ! grep -q 'SAL_USE_VCLPLUGIN' "$HYPR/envs.conf"; then
    cat >> "$HYPR/envs.conf" << 'EOF'

# LibreOffice Wayland scaling fix
env = SAL_USE_VCLPLUGIN,gtk3
EOF
  fi
  if ! grep -q 'NVD_BACKEND' "$HYPR/envs.conf"; then
    cat >> "$HYPR/envs.conf" << 'EOF'

# NVIDIA
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  fi
  echo "  envs.conf: patched"
else
  # No omarchy template exists yet — create the file
  cat > "$HYPR/envs.conf" << 'EOF'
# LibreOffice Wayland scaling fix
env = SAL_USE_VCLPLUGIN,gtk3

# NVIDIA
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  echo "  envs.conf: created"
fi
